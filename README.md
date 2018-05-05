# Minio Fly.io Wormhole

Want to create your own distributed S3-type service? Don't want to configure load balancing and encryption in Nginx? Want all your servers on one domain/sub-domain? Give this method a try, and check out the rest of [fly.io](https://fly.io) for other cool stuff.

Based on this [load balancing comparison](https://fly.io/articles/load-balancing-a-fleet-of-docker-containers-using-fly/) article from fly.io, comparing their solution with Nginx.

Now this Docker image and setup file make it even to do with Minio.

## Quick start

If you haven't already, set up a Docker Swarm of 4 or more nodes. Do this by logging on to a manager machine and doing `docker swarm init` and following the instructions. It will ask you to run a command on the 3 other nodes.

You only need to copy and edit the [`minio-swarm.yaml`](minio-swarm.yaml) file in this directory and run it like so `docker stack deploy --compose-file=minio-swarm.yaml minio`. But make sure to **edit** the file as below:

```yaml
# I have set this up to use persistent block storage mounted to `/mnt/block-storage/var/lib/minio`.
# You can leave this the same, or use another folder. Or you can use Docker
# volumes. For that, see the auto-generated yaml at minio.io.
volumes:
 - type: bind
   source: /mnt/block-storage/var/lib/minio
```

```yaml
# Create a seperate access key and secret key. You can also do this at minio.io. I've included a node script to do the same: minio_key_generator.js (see footnote)
# Your fly.io token is found at https://fly.io/sites/YOUR-SITE-NAME/backends/ (and click on your backend, then "Show Agent Token")
environment:
 MINIO_ACCESS_KEY: VARS-GO-HERE
 MINIO_SECRET_KEY: VARS-GO-HERE
 FLY_TOKEN: VARS-GO-HERE
```

The config should be the same for each entry. Then, put the `.yaml` file on your swarm manager server (where you ran `docker swarm init` from) and do `docker stack deploy --compose-file=minio-swarm.yaml minio`.

Check the status of the swarm deploy with `docker stack ps minio` and wait till all services are running. Then check [fly.io](https://fly.io/sites) under backends to see if the endpoints show up (I had to log in again until I saw them, did not take long though).

Footnote: I'm not a cryptographer, use the keys from `node minio_key_generator.js` at your own risk. 

## Explore Further
- [Fly.io articles about how you can program your own CDN](https://fly.io/articles/)
- [Minio Erasure Code QuickStart Guide](https://docs.minio.io/docs/minio-erasure-code-quickstart-guide)
- [Use `mc` with Minio Server](https://docs.minio.io/docs/minio-client-quickstart-guide)
- [Use `aws-cli` with Minio Server](https://docs.minio.io/docs/aws-cli-with-minio)
- [Use `s3cmd` with Minio Server](https://docs.minio.io/docs/s3cmd-with-minio)
- [Use `minio-go` SDK with Minio Server](https://docs.minio.io/docs/golang-client-quickstart-guide)
- [The Minio documentation website](https://docs.minio.io)

## Contribute to Minio Project
Please follow Minio [Contributor's Guide](https://github.com/minio/minio/blob/master/CONTRIBUTING.md)

## Minio License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fminio%2Fminio.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fminio%2Fminio?ref=badge_large)
