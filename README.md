# homebrew-python-vendoring-scripts

A few scripts to help automate the process of migrating most Python-based formulae back into vendored resources.

## Usage

Currently there are two scripts, which each have a hardcoded list of formulae or PyPi package names. These lists should contain the full list of formulae/packages to be vendored.

If you need to modify the formulae/pypi package lists, edit the lists in the scripts directly.

The scripts can be run out of this repo checkout, and assume you have homebrew-core tapped.

### Remove excluded PyPi packages from formula mappings

With a basic Ruby environment loaded, run the `remove-excluded-pypi-packages.rb` script to remove some the excluded packages from `pypi_formula_mappings.json`:

```bash
./remove-excluded-pypi-packages.rb
```

### Update Python resources in formulas

Run `update-formula-files.sh` next, to make the initial formula updates:

```bash
./update-formula-files.sh
```

This will (1) remove the appropriate `depends_on` lines in formulas, and (2) run `brew update-python-resources <formula>` on all formulae which are modified (according to Git).

## Next steps

Take a look at the formula changes and see if they make sense, or might need additional edits.

If the formula didn't previously have anything vendored, it should also set its install method to use the `virtualenv_install_with_resources` method and `include Language::Python::Virtualenv` in the formula.

Test out the installation and open a PR for the formula and `pypi_formula_mappings.json` change.
