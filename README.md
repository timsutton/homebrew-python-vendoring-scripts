# homebrew-python-vendoring-scripts

A few scripts to help automate the process of migrating most Python-based formulae back into vendored resources.

## Usage

Currently there are two scripts, which each have a hardcoded list of formulae or PyPi package names. These lists should contain the full list of formulae/packages to be vendored.

The scripts can be run out of this repo checkout, and assume you have homebrew-core tapped.

### Remove excluded PyPi packages from formula mappings

With a basic Ruby environment loaded, run the `remove-excluded-pypi-packages.rb` script to remove some the excluded packages from `pypi_formula_mappings.json`:

```bash
./remove-excluded-pypi-packages.rb
```

### Update Python resources in formulas

Run `update-formula-files.sh` next, to make the initial formula updates. This will (1) remove the appropriate `depends_on` lines in formulas, and (2) run `brew update-python-resources <formula>` on all formulae which are modified (according to Git).

## Next steps

Take a look at the formula changes and see if they make sense, or might need additional edits. Test out the installation and open a PR for the formula and `pypi_formula_mappings.json` change.
