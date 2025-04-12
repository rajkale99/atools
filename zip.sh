for dir in odm product system system_ext vendor; do
    sudo zip -r "${dir}.zip" "$dir"
done
