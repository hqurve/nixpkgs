#!@shell@

# placed here to make lauchner readable
out=@out@
JARs_dir=@JARs_dir@
configPath=@configPath@

tmp_dir=$(mktemp -d /tmp/jdtls.XXXXX)
cp -R $JARs_dir/$configPath $tmp_dir
chmod -R +w $tmp_dir

trap "{ rm -rf $tmp_dir; }" EXIT

@java@ \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -jar $JARs_dir/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $tmp_dir/$configPath \
    "$@"
