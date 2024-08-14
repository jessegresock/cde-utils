submit-session() {
    _file=$1

    # Build temporary resource
    resource_nm="tmp_resource_$(date +%s)"
    cde resource create --name $resource_nm --type "files" --retention-policy "delete_after_run"

    # Upload file to resource
    cde resource upload --local-path $_file --name $resource_nm

    #cde session create --name $resource_nm --type "pyspark" --mount-1-resource $resource_nm --py-file "$_file"
    cde job create --name $resource_nm --type "spark" --mount-1-resource $resource_nm --application-file $_file

    id=$(cde job run --name $resource_nm | awk -F '[:,]' '{gsub(/[ \t\r\n\"]*/, "", $2); print $2}') 

    cde run logs --id $id --type driver/stdout --follow
}