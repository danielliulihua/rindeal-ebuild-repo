Rindeal's Ebuild Repository <img src="./assets/logo_96.png" title="Sir Benjamin the Bull" alt="logo" align="right">
============================

<i>Packages done right™</i>

<!---
----------------------------------- BADGES -------------------------------------
--->

[![][badge-ci-master]](https://travis-ci.com/rindeal/rindeal-ebuild-repo)
[![][badge-docker-label]![][badge-docker]](https://hub.docker.com/r/rindeal/portage-amd64-base/)
[![][badge-code-quality]](https://www.codacy.com/app/rindeal/rindeal-ebuild-repo)
<br/>
[![][badge-commit-stats-label]][git-commits-master]
[![][badge-first-commit]][git-first-commit][![][badge-last-commit]][git-commits-master]
[![][badge-commit-cadence-label]![][badge-commit-cadence-week]![][badge-commit-cadence-month]![][badge-commit-cadence-year]][github-pulse]
[![][badge-commits-queued]][git-compare-master-dev]

<!---
----------------------------------- MENU ---------------------------------------
--->

[Homepage][homepage] | [Issue tracker][issue-tracker] | **[Installation instructions][installation-instructions]**

<!---
------------------------------ DOCUMENT_START ----------------------------------
--->

This repository contains [ebuild][wiki-ebuild]s and related files for [PMS][wiki-pms]-compatible package managers such as [Portage][wiki-portage].

**Warning**: This repository is not an overlay for [Gentoo™][] repository! At the moment it's still a requirement for some things to work,
but I'm working towards a complete independence, which means independent ebuilds, eclasses and profiles for a fully working basic system.
To give an example of incompatibilities, I'm using quite different guidelines and policies for USE-flags, so your [Gentoo™][] config files may not
enable/disable the features you expect it to.
For this reason don't expect things to work smoothly if you use this repository just as a pure overlay for [Gentoo™][] repository.

Otherwise, enjoy your ride!

--------------------------------------------------------------------------------

### Legal notice

- All code in this repo is licenced under [GPL-2](./LICENSE), if not stated otherwise.
- _[Gentoo™][]_ is a trademark of the _Gentoo Foundation, Inc._
- [Animal vector designed by Freepik](https://www.freepik.com/free-vector/polygonal-bull-head_747949.htm)

<!---
------------------------------ END_OF_DOCUMENT ---------------------------------
--->

[Gentoo™]: https://www.gentoo.org/ "main Gentoo project website"
[wiki-ebuild]: https://wiki.gentoo.org/wiki/Ebuild
[wiki-pms]: https://wiki.gentoo.org/wiki/Package_Manager_Specification
[wiki-portage]: https://wiki.gentoo.org/wiki/Portage

[homepage]: https://github.com/rindeal/rindeal-ebuild-repo
[issue-tracker]: https://github.com/rindeal/rindeal-ebuild-repo/issues
[installation-instructions]: ./INSTALL.md#how-to-install-this-repository

[github-pulse]: https://github.com/rindeal/rindeal-ebuild-repo/pulse "GitHub Pulse for rindeal-ebuild-repo"
[docker-hub-project]: https://hub.docker.com/r/rindeal/portage-amd64-base/
[git-first-commit]:            https://github.com/rindeal/rindeal-ebuild-repo/commit/a7fdc35fde3388c2bf95b8beab8a14afb7082f31
[git-commits-master]:          https://github.com/rindeal/rindeal-ebuild-repo/commits/master
[git-compare-master-dev]:      https://github.com/rindeal/rindeal-ebuild-repo/compare/master...dev/rindeal

[badge-ci-master]:             https://img.shields.io/travis/rindeal/rindeal-ebuild-repo/master.svg?style=flat-square&label=CI@master&cacheSeconds=300
[badge-docker-label]:          https://img.shields.io/badge/-image-gray.svg?style=flat-square&logo=docker&cacheSeconds=86400
[badge-docker]:                https://semaphoreci.com/api/v1/rindeal/portage-docker-images/branches/master/shields_badge.svg
[badge-code-quality]:          https://img.shields.io/codacy/grade/3705846277d040f0946ac4d4e34c715f?logo=Codacy&style=flat-square&cacheSeconds=60
[badge-commit-stats-label]:    https://img.shields.io/badge/-commit%20stats:-gray.svg?style=flat-square&cacheSeconds=86400
[badge-first-commit]:          https://img.shields.io/date/1439332378.svg?label=first&style=flat-square&cacheSeconds=86400
[badge-last-commit]:           https://img.shields.io/github/last-commit/rindeal/rindeal-ebuild-repo/master.svg?label=last&style=flat-square&cacheSeconds=300
[badge-commit-cadence-label]:  https://img.shields.io/badge/-cadence-gray.svg?style=flat-square&cacheSeconds=86400
[badge-commit-cadence-week]:   https://img.shields.io/github/commit-activity/w/rindeal/rindeal-ebuild-repo.svg?label=&style=flat-square&cacheSeconds=60
[badge-commit-cadence-month]:  https://img.shields.io/github/commit-activity/m/rindeal/rindeal-ebuild-repo.svg?label=&style=flat-square&cacheSeconds=60
[badge-commit-cadence-year]:   https://img.shields.io/github/commit-activity/y/rindeal/rindeal-ebuild-repo.svg?label=&style=flat-square&cacheSeconds=60
[badge-commits-queued]:        https://img.shields.io/github/commits-since/rindeal/rindeal-ebuild-repo/master/dev/rindeal.svg?label=queued&style=flat-square&cacheSeconds=600
