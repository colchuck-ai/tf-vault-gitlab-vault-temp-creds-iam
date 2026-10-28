#!/usr/bin/env sh

if [ -d ./environments ]; then
    echo "Found ./environments directory. Generating documentation."
    for environment_dir in ./environments/*; do
        for provider_dir in $environment_dir/*; do
            for region_dir in $provider_dir/*; do
                echo "Generating documentation for module directory: $region_dir"
                if terraform-docs "$region_dir" > "$region_dir/README.md"; then
                    prettier --write "$region_dir/README.md"
                    git add -v "./$region_dir/README.md"
                fi
            done
        done
    done
else
    echo "No ./environments directory found. Skipping generating documentation."
fi

find . -type d -regex "^\\.[^\.]*/modules$" | while read -r modules_dir; do
    for module_dir in $modules_dir/*; do
        echo "Generating documentation for module directory: $module_dir"
        if terraform-docs "$module_dir" > "$module_dir/README.md"; then
            prettier --write "$module_dir/README.md"
            git add -v "./$module_dir/README.md"
        fi
    done
done