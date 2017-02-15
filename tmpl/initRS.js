rs.initiate({
  members: [
    { host: "{{mongo.ip}}:27017", arbiterOnly: false, _id: 0 }
  ],
  _id: "{{mongo.install}}"
})
