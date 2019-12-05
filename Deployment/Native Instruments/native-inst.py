mkdir ~/Library/AutoPkg/RecipeOverrides/NativeInstruments
python ~/Library/AutoPkg/RecipeRepos/com.github.uoe-macos.autopkg-recipes/Native\ Instruments/native_instruments_helper.py\
                --template-autopkg-override \
                --template-override-source ~/Library/AutoPkg/RecipeOverrides/NativeInstrumentsProduct.munki.recipe \
                --template-override-dest-dir ~/Library/AutoPkg/RecipeOverrides/NativeInstruments \
                --suite=komplete --major-version=12
