#!/bin/bash

set -euo pipefail

brew_formulae_to_vendor=(
  pygments
  python-click
  python-dateutil
  python-markupsafe
  python-packaging
  python-psutil
  python-pyparsing
  python-pytz
  python-tabulate
  python-typing-extensions
  python-urllib3
  pyyaml
  six
)

# If you want to resume from a specific point in the alpha list of formulae,
# set this variable to something, otherwise leave it unset.
resume_from_formula="bpytop"

function setup() {
  command -v rg >/dev/null || brew install ripgrep
  command -v gsed >/dev/null || brew install gnu-sed
}

function remove_depends_on() {
  for formula in "${brew_formulae_to_vendor[@]}"; do
    rg --files-with-matches "$formula" | xargs gsed -i '/depends_on \"'"$formula"'\"/d'
  done
}

function run_update_python_resources() {
  rm -f failed_to_update_formulae.txt

  found_resume_point=

  for f_file in $(git ls-files -m | grep Formula); do
    formula_name="$(echo "$(basename "${f_file}")" | cut -d. -f1)"

    if [[ -z "${found_resume_point}" ]] && [[ "${formula_name}" = "${resume_from_formula}" ]]; then
      found_resume_point=1
    fi

    if [[ -z "${found_resume_point}" ]] && [[ -n "${resume_from_formula}" ]]; then
      echo "Skipping $formula_name..."
      continue
    fi

    echo "Running update-python-resources for $formula_name..."
    # We allow failure because in some cases 'update-python-resources' will
    # fail to be able to update everything. Because this process takes a while
    # it's better to just let it go through whatever it can
    if ! brew update-python-resources "${formula_name}"; then
      echo "Failed to update $formula_name, adding to failed_to_update_formulae.txt"
      echo "${formula_name}" >>failed_to_update_formulae.txt
    fi
  done
}

(
  cd "$(brew --prefix)/Library/Taps/homebrew/homebrew-core"
  setup
  remove_depends_on
  run_update_python_resources
)
