# Upgrading dj-stripe Smooth and Carefully

## Background

In this article, we will share how to upgrade the `dj-stripe` package flawlessly and carefully.

Please keep in mind that `dj-stripe` always squashes the migration files.
Which means its migration files are completely changed, and leading to migration issues.
**So, you can't immediately upgrade your package too far, for example, from `2.4.0` to `2.7.0` because it will cause breaking changes, especially in your database migrations.**

## How to do it?

For example, if your `dj-stripe` version is `2.4.0` and your migration files are referring to the old version.

![old migration file](https://github.com/agusmakmun/agusmakmun.github.io/assets/7134451/d433d048-d3cf-4385-a7f6-f1890acfe206)

First, you need to find which version has that old migration. For example:

1. Search for the latest version that is closest to your package version, for example: `2.4.0` to `2.5.0`.
2. Visit [the releases page link](https://github.com/dj-stripe/dj-stripe/releases) to find it
3. Cross-check the release notes.
4. Find which dj-stripe version is still compatible with your migration file, for example: `0006_2_3.py`.
5. Find the last migration file of the latest version at [/djstripe/migrations/](https://github.com/dj-stripe/dj-stripe/tree/2.5.0/djstripe/migrations) (for example: `0008_2_5.py`) (both files must exist; if not, it means the new version is no longer compatible with your version).
6. Update your requirements file from `dj-stripe==2.4.0` to `dj-stripe==2.5.0`
7. Run the `manage.py migrate djstripe` command _(this command must not fail; if it does, cross-check steps 1-6)._

```bash
$ docker-compose -f local.yml run django python manage.py migrate djstripe
[+] Creating 3/0
 ✔ Container my-project-redis-1     Running
 ✔ Container my-project-mailhog-1   Running
 ✔ Container my-project-postgres-1  Running
PostgreSQL is available
System check identified some issues:

Operations to perform:
  Apply all migrations: djstripe
Running migrations:
  Applying djstripe.0008_2_5... OK
```

8. And then, after migrating it, change your migration file to refer to the new version (e.g., from `0006_2_3` to `0008_2_5`).

![change migration file](https://github.com/agusmakmun/agusmakmun.github.io/assets/7134451/70ebe2d4-d780-4994-b05b-e361fc95dd3d)

9. Repeat the same process for higher version.

If you have an issue with the Stripe version, we can also try upgrading it in your requirements file.
Check out [issue #1842](https://github.com/dj-stripe/dj-stripe/issues/1842#issuecomment-1319185657) for more information.

## Conclusion

1. Find the closest version that compatible with your version _(for doing migration)_.
2. Update the dependency in `requirements.txt` file and then deploy it.
    - Don't forget to run the `python manage.py migrate djstripe` command.
3. Change your migration file to refer to the new version (e.g., from `0006_2_3` to `0008_2_5`), and then deploy it.

## Alternatives

-   [https://stackoverflow.com/a/31122841](https://stackoverflow.com/a/31122841)
