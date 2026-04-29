hugo --minify
rsync -av --delete -e ssh ./public/ auttools-host:/mnt/nvme/Apps/www-AutTools/