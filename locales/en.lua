local Translations = {

  label = {
    jobStash = 'Job Stash',
    gangStash = 'Gang Stash',
    raidStash = 'Police Raid Stash',
    raidStash2 = 'Admin Raid Stash',
  }
  webhook = {
    policeRaid = 'Officer %s is raiding stash: %s',
    adminRaid = 'Admin %s is opening stash: %s',
  }
  debug = {
    loadingModel = '^5Debug^7: ^2Loading Model^7: ^6%s^7',
    modelTO = '^5Debug^7: ^3LoadModel^7: ^1Timed out loading model^7: ^8%s^7',
    propCreated = '^5Debug^7: ^6Prop Created ^7: ^8%s^7',
    propCreated2 = 'prop %s, Money Counter #%s Created at %s',
  },
  notify = {
    invalidStash = 'Not a valid stash. Please check the stash and box numbers again.',
  }

}

Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true
})