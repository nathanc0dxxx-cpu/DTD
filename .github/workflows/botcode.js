async function main(){
const owner = "tutugrande1235"
const repo = "tutugrande1235-DTD"
const issue_number = 7
const comment = context.payload.comment.body
let reply = ""
const cbody = comment.split("@")
const user = cbody[0] || "User"
const to = cbody[1] || "User"
let form = ""
const c = cbody[2] || "nil"

if (!c || !user || !to){
  return
}

console.log("user: " + user + "\nbody: " + c)

if (c.includes("test")){
  reply = `dont test me @${user}!`
} else if (c.includes("bad")) {
  reply = `@${user} dont be SUCK!`
}

if (reply){
  form = `System@${user}@${reply}`
}

await github.issues.createComment({
  owner: owner,
  repo: repo,
  issue_number: issue_number,
  body: form
})

}

main()