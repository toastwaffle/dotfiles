#!/usr/bin/env python3
"""Generate a virtualenv script which installs bpython."""

import os
import textwrap
import virtualenv

SCRIPT_NAME = os.path.join(os.path.dirname(__file__), 'make_virtualenv.py')

with open(SCRIPT_NAME, 'w') as f:
    f.write(virtualenv.create_bootstrap_script(textwrap.dedent("""
        import subprocess

        def after_install(_, home_dir):
            subprocess.call([
                join(home_dir, 'bin', 'pip'),
                'install',
                'bpython',
            ])
    """)))
