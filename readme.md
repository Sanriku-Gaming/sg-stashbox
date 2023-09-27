# SG Stashbox

Advanced stash management system with job, gang, police and admin access options.

## Features

- Configurable stashes per job and gang
- Police can raid any stash
- Admins can access all stashes
- Prop spawning at stash locations
- Webhook logging for unauthorized access

## Requirements

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu) (for stash menus)
- [qb-smallresources](https://github.com/qbcore-framework/qb-smallresources) (for webhooks)

## Installation

1. Download the latest version
2. Place `sg-stashbox` into your `resources` or `standalone` folder (remove `-main` from folder if necessary)
3. Add `ensure sg-stashbox` to your server.cfg (after all qb scripts), unless in `standalone` folder
4. Configure options in `config.lua` to your liking
5. Restart server

See config for full setup details.

## Configuration

The main configuration is in `config.lua`:

- Set stash locations, sizes, jobs/gangs
- Customize police raid options
- Setup admin permissions
- Enable webhooks

## Usage

Stashes can be accessed through target interactions.

Police and admins can raid stashes based on configured permissions.

## Credits

- Created by: [Nicky](https://forum.cfx.re/u/Sanriku)
- [SG Scripts Discord](https://discord.gg/uEDNgAwhey)
- Inspired by: [qb-stashbox](https://github.com/oosayeroo/qb-stashbox)