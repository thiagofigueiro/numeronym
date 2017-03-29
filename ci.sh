#!/bin/bash
set -eux
source "/usr/local/test.shared-scripts/build_steps/functions.sh"

# TODO: find a better way
cp -f app.blueprint app.blueprint~
cp -f setup.py setup.py~

rm -rf dist build *.egg-info .version
pip install pytest-cov
pip install -e .
# Do not replace `pytest` with `python setup.py test`. The latter uses
# easy_install which ignores ~/.pip/pip.conf.
pytest # see setup.cfg for options

echo -n "${PACKAGE_VERSION}" > .version
if [ "$RELEASE_BRANCH" == "$GIT_BRANCH" ]; then
    PIP_REPO='acp'
else
    PIP_REPO='acp-ci'
    blueprint bump metadata "ci-build-${BUILD_NUMBER}" || true
fi

# Create egg and wheel packages
python setup.py sdist bdist_wheel upload -r "${PIP_REPO}"
mv app.blueprint~ app.blueprint || true
mv setup.py~ setup.py || true
