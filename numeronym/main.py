class Numeronym:
    def __init__(self, short=None, preserve_case=None):
        # Default variables
        self.allow_short        = False
        if short:
            self.allow_short    = short

        self.preserve_case      = False
        if preserve_case is not None:
            self.preserve_case  = preserve_case


    def encode(self, input, padding=1):
        if len(input) < 3:
            if self.allow_short == True:
                f = input[0]
                output = "%s%d" % (f, len(input[1:]))

                if self.preserve_case == False:
                    output = output.lower()

                return output
            else:
                raise Exception("Input string must be at least three characters in length")
        else:
            f = input[0]
            l = input[-1]
            template = "%s%0{padding}d%s".format(**locals())

            output = template % (f, len(input[1:-1]), l)

            if self.preserve_case == False:
                output = output.lower()

            return output
