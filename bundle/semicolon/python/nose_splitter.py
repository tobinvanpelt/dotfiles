"""
Splits nose output into a summary of results sent to stdout and of error
results sent to a file.

This module was extended from https://github.com/nvie/nose-machineout

"""

import os
import sys
import traceback
import time
import nose
from nose.plugins import Plugin


class DummyStream:
    def write(self, *arg):
        pass

    def writeln(self, *arg):
        pass

    def flush(self):
        pass


class ResultsSplitter(Plugin):
    """
    Output errors and failures to a seperate file.
    """

    name = 'results-splitter'

    def __init__(self):
        super(ResultsSplitter, self).__init__()

        self.basepath = os.getcwd()

        self.out_stream = None

        self.t0 = None
        self.success = 0
        self.failure = 0
        self.error = 0

    def options(self, parser, env):
        super(ResultsSplitter, self).options(parser, env)
        parser.add_option('--err-file', dest='err_file')

    def configure(self, options, conf):
        super(ResultsSplitter, self).configure(options, conf)
        err_file = options.err_file

        if err_file is None:
            self.err_stream = DummyStream()
        else:
            self.err_stream = open(err_file, 'w')

    def addError(self, test, err):
        self.error += 1
        self.out_stream.write('E')
        self._stderr('error', err)

    def addFailure(self, test, err):
        self.failure += 1
        self.out_stream.write('F')
        self._stderr('fail', err)

    def addSuccess(self, test):
        self.success += 1
        self.out_stream.write('.')

    def begin(self):
        self.t0 = time.clock()

    def finalize(self, result):
        time_exp = time.clock() - self.t0

        self.out_stream.writeln('')
        num = self.success + self.failure + self.error
        head = '%i tests (%.3f s):' % (num, time_exp)

        tail = ''
        if self.failure > 0 or self.error > 0:
            if self.failure > 0:
                tail += '  failures = %i' % self.failure
            if self.error > 0:
                tail += '  errors = %i' % self.error
        else:
            tail += '  All passed.'

        res = head + tail
        self.out_stream.writeln('-' * 70)
        self.out_stream.writeln(res)

        try:
            self.err_stream.close()
        except:
            pass

    def setOutputStream(self, stream):
        self.out_stream = stream
        self.out_stream.writeln('=' * 70)
        return DummyStream()

    def _calcScore(self, frame):
        """Calculates a score for this stack frame, so that can be used as a
        quality indicator to compare to other stack frames in selecting the
        most developer-friendly one to show in one-line output.
        """
        fname, _, funname, _ = frame
        score = 0.0
        max_score = 7.0  # update this when new conditions are added

        # Being in the project directory means it's one of our own files
        if fname.startswith(self.basepath):
            score += 4

        # Being one of our tests means it's a better match
        if os.path.basename(fname).find('test') >= 0:
            score += 2

        # The check for the `assert' prefix allows the user to extend
        # unittest.TestCase with custom assert-methods, while
        # machineout still returns the most useful error line number.
        if not funname.startswith('assert'):
            score += 1
        return score / max_score

    def _selectBestStackFrame(self, traceback):
        best_score = 0
        best = traceback[-1]   # fallback value
        for frame in traceback:
            curr_score = self._calcScore(frame)
            if curr_score > best_score:
                best = frame
                best_score = curr_score

                # Terminate the walk as soon as possible
                if best_score >= 1:
                    break
        return best

    def _stderr(self, etype, err):
        exctype, value, tb = err
        fulltb = traceback.extract_tb(tb)
        fname, lineno, funname, msg = self._selectBestStackFrame(fulltb)

        lines = traceback.format_exception_only(exctype, value)
        lines = [line.strip('\n') for line in lines]
        msg = lines[0]

        fname = self._format_testfname(fname)
        prefix = '%s:%d' % (fname, lineno)
        self.err_stream.write('%s: %s: %s' % (prefix, etype, msg))

        if len(lines) > 1:
            pad = ' ' * (len(etype) + 1)
            for line in lines[1:]:
                self.err_stream.write('%s: %s %s' % (prefix, pad, line))

        self.err_stream.write('\n')

    def _format_testfname(self, fname):
        if fname.startswith(self.basepath):
            return fname[len(self.basepath) + 1:]

        return fname


if __name__ == '__main__':
    # used to run nosetests with plugin active
    nose.run(argv=sys.argv, addplugins=[ResultsSplitter()])
