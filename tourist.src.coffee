class HelloWorld
  @test: 'test'
console.log('hi')
class HelloWorld
  @test: 'test'
console.log('hi')
class HelloWorld
  @test: 'test'
console.log('hi')
system = require 'system'
if system.args.length is 1
  console.log 'Try to pass some args when invoking this script!'
else
  for arg, i in system.args
    console.log i + ': ' + arg
phantom.exit()

{spawn, execFile} = require "child_process"

child = spawn "ls", ["-lF", "/rooot"]

child.stdout.on "data", (data) ->
  console.log "spawnSTDOUT:", JSON.stringify data

child.stderr.on "data", (data) ->
  console.log "spawnSTDERR:", JSON.stringify data

child.on "exit", (code) ->
  console.log "spawnEXIT:", code

#child.kill "SIGKILL"

execFile "ls", ["-lF", "/usr"], null, (err, stdout, stderr) ->
  console.log "execFileSTDOUT:", JSON.stringify stdout
  console.log "execFileSTDERR:", JSON.stringify stderr

setTimeout (-> phantom.exit 0), 2000

page = require('webpage').create()

page.viewportSize = { width: 400, height : 400 }
page.content = '<html><body><canvas id="surface"></canvas></body></html>'

page.evaluate ->
  el = document.getElementById 'surface'
  context = el.getContext '2d'
  width = window.innerWidth
  height = window.innerHeight
  cx = width / 2
  cy = height / 2
  radius = width / 2.3
  i = 0

  el.width = width
  el.height = height
  imageData = context.createImageData(width, height)
  pixels = imageData.data

  for y in [0...height]
    for x in [0...width]
      i = i + 4
      rx = x - cx
      ry = y - cy
      d = rx * rx + ry * ry
      if d < radius * radius
        hue = 6 * (Math.atan2(ry, rx) + Math.PI) / (2 * Math.PI)
        sat = Math.sqrt(d) / radius
        g = Math.floor(hue)
        f = hue - g
        u = 255 * (1 - sat)
        v = 255 * (1 - sat * f)
        w = 255 * (1 - sat * (1 - f))
        pixels[i] = [255, v, u, u, w, 255, 255][g]
        pixels[i + 1] = [w, 255, 255, v, u, u, w][g]
        pixels[i + 2] = [u, u, w, 255, 255, v, u][g]
        pixels[i + 3] = 255

  context.putImageData imageData, 0, 0
  document.body.style.backgroundColor = 'white'
  document.body.style.margin = '0px'

page.render('colorwheel.png')

phantom.exit()

t = 10
interval = setInterval ->
  if t > 0
    console.log t--
  else
    console.log 'BLAST OFF!'
    phantom.exit()
, 1000

page = require('webpage').create()
system = require 'system'

page.onInitialized = ->
  page.evaluate ->
    userAgent = window.navigator.userAgent
    platform = window.navigator.platform
    window.navigator =
      appCodeName: 'Mozilla'
      appName: 'Netscape'
      cookieEnabled: false
      sniffed: false

    window.navigator.__defineGetter__ 'userAgent', ->
      window.navigator.sniffed = true
      userAgent

    window.navigator.__defineGetter__ 'platform', ->
      window.navigator.sniffed = true
      platform

if system.args.length is 1
  console.log 'Usage: detectsniff.coffee <some URL>'
  phantom.exit 1
else
  address = system.args[1]
  console.log 'Checking ' + address + '...'
  page.open address, (status) ->
    if status isnt 'success'
      console.log 'FAIL to load the address'
      phantom.exit()
    else
      window.setTimeout ->
        sniffed = page.evaluate(->
          navigator.sniffed
        )
        if sniffed
          console.log 'The page tried to sniff the user agent.'
        else
          console.log 'The page did not try to sniff the user agent.'
        phantom.exit()
      , 1500

# Get driving direction using Google Directions API.

page = require('webpage').create()
system = require 'system'

if system.args.length < 3
  console.log 'Usage: direction.coffee origin destination'
  console.log 'Example: direction.coffee "San Diego" "Palo Alto"'
  phantom.exit 1
else
  origin = system.args[1]
  dest = system.args[2]
  page.open encodeURI('http://maps.googleapis.com/maps/api/directions/xml?origin=' + origin +
                      '&destination=' + dest + '&units=imperial&mode=driving&sensor=false'),
            (status) ->
              if status isnt 'success'
                console.log 'Unable to access network'
              else
                steps = page.content.match(/<html_instructions>(.*)<\/html_instructions>/ig)
                if not steps
                  console.log 'No data available for ' + origin + ' to ' + dest
                else
                  for ins in steps
                    ins = ins.replace(/\&lt;/ig, '<').replace(/\&gt;/ig, '>')
                    ins = ins.replace(/\<div/ig, '\n<div')
                    ins = ins.replace(/<.*?>/g, '')
                    console.log(ins)
                  console.log ''
                  console.log page.content.match(/<copyrights>.*<\/copyrights>/ig).join('').replace(/<.*?>/g, '')
              phantom.exit()

# echoToFile.coffee - Write in a given file all the parameters passed on the CLI
fs = require 'fs'
system = require 'system'

if system.args.length < 3
  console.log "Usage: echoToFile.coffee DESTINATION_FILE <arguments to echo...>"
  phantom.exit 1
else
  content = ""
  f = null
  i = 2
  while i < system.args.length
    content += system.args[i] + (if i == system.args.length - 1 then "" else " ")
    ++i
  try
    fs.write system.args[1], content, "w"
  catch e
    console.log e
  phantom.exit()

feature = undefined
supported = []
unsupported = []
phantom.injectJs "modernizr.js"
console.log "Detected features (using Modernizr " + Modernizr._version + "):"
for feature of Modernizr
  if Modernizr.hasOwnProperty(feature)
    if feature[0] isnt "_" and typeof Modernizr[feature] isnt "function" and feature isnt "input" and feature isnt "inputtypes"
      if Modernizr[feature]
        supported.push feature
      else
        unsupported.push feature
console.log ""
console.log "Supported:"
supported.forEach (e) ->
  console.log "  " + e

console.log ""
console.log "Not supported:"
unsupported.forEach (e) ->
  console.log "  " + e

phantom.exit()
fibs = [0, 1]
f = ->
  console.log fibs[fibs.length - 1]
  fibs.push fibs[fibs.length - 1] + fibs[fibs.length - 2]
  if fibs.length > 10
    window.clearInterval ticker
    phantom.exit()
ticker = window.setInterval(f, 300)

# List following and followers from several accounts

users = [
  'PhantomJS'
  'ariyahidayat'
  'detronizator'
  'KDABQt'
  'lfranchi'
  'jonleighton'
  '_jamesmgreene'
  'Vitalliumm'
  ]

follow = (user, callback) ->
  page = require('webpage').create()
  page.open 'http://mobile.twitter.com/' + user, (status) ->
    if status is 'fail'
      console.log user + ': ?'
    else
      data = page.evaluate -> document.querySelector('div.profile td.stat.stat-last div.statnum').innerText;
      console.log user + ': ' + data
    page.close()
    callback.apply()

process = () ->
  if (users.length > 0)
    user = users[0]
    users.splice(0, 1)
    follow(user, process)
  else
    phantom.exit()

process()

console.log 'Hello, world!'
phantom.exit()

# Upload an image to imagebin.org

page = require('webpage').create()
system = require 'system'

if system.args.length isnt 2
  console.log 'Usage: imagebin.coffee filename'
  phantom.exit 1
else
  fname = system.args[1]
  page.open 'http://imagebin.org/index.php?page=add', ->
    page.uploadFile 'input[name=image]', fname
    page.evaluate ->
      document.querySelector('input[name=nickname]').value = 'phantom'
      document.querySelector('input[name=disclaimer_agree]').click()
      document.querySelector('form').submit()

    window.setTimeout ->
      phantom.exit()
    , 3000

# Use 'page.injectJs()' to load the script itself in the Page context

if phantom?
  page = require('webpage').create()

  # Route "console.log()" calls from within the Page context to the main
  # Phantom context (i.e. current "this")
  page.onConsoleMessage = (msg) -> console.log(msg)

  page.onAlert = (msg) -> console.log(msg)

  console.log "* Script running in the Phantom context."
  console.log "* Script will 'inject' itself in a page..."
  page.open "about:blank", (status) ->
    if status is "success"
      if page.injectJs("injectme.coffee")
        console.log "... done injecting itself!"
      else
        console.log "... fail! Check the $PWD?!"
    phantom.exit()
else
  alert "* Script running in the Page context."


# Give the estimated location based on the IP address.

window.cb = (data) ->
  loc = data.city
  if data.region_name.length > 0
    loc = loc + ', ' + data.region_name
  console.log 'IP address: ' + data.ip
  console.log 'Estimated location: ' + loc
  phantom.exit()

el = document.createElement 'script'
el.src = 'http://freegeoip.net/json/?callback=window.cb'
document.body.appendChild el

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: loadspeed.coffee <some URL>'
  phantom.exit 1
else
  t = Date.now()
  address = system.args[1]
  page.open address, (status) ->
    if status isnt 'success'
      console.log('FAIL to load the address')
    else
      t = Date.now() - t
      console.log('Page title is ' + page.evaluate( (-> document.title) ))
      console.log('Loading time ' + t + ' msec')
    phantom.exit()


page = require("webpage").create()
system = require("system")

if system.args.length < 2
  console.log "Usage: loadurlwithoutcss.js URL"
  phantom.exit()

address = system.args[1]

page.onResourceRequested = (requestData, request) ->
  if (/http:\/\/.+?\.css/g).test(requestData["url"]) or requestData["Content-Type"] is "text/css"
    console.log "The url of the request is matching. Aborting: " + requestData["url"]
    request.abort()

page.open address, (status) ->
  if status is "success"
    phantom.exit()
  else
    console.log "Unable to load the address!"
    phantom.exit()

universe = require './universe'
universe.start()
console.log 'The answer is' + universe.answer
phantom.exit()

# List movies from kids-in-mind.com

window.cbfunc = (data) ->
  globaldata = data
  list = data.query.results.movie
  for item in list
    console.log item.title + ' [' + item.rating.MPAA.content + ']'
  phantom.exit()

el = document.createElement 'script'
el.src =
"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20movies.kids-in-mind&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=window.cbfunc"
document.body.appendChild el

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: netlog.coffee <some URL>'
  phantom.exit 1
else
  address = system.args[1]
  page.onResourceRequested = (req) ->
    console.log 'requested ' + JSON.stringify(req, undefined, 4)

  page.onResourceReceived = (res) ->
    console.log 'received ' + JSON.stringify(res, undefined, 4)

  page.open address, (status) ->
    if status isnt 'success'
      console.log 'FAIL to load the address'
    phantom.exit()

if not Date::toISOString
  Date::toISOString = ->
    pad = (n) ->
      if n < 10 then '0' + n else n
    ms = (n) ->
      if n < 10 then '00' + n else (if n < 100 then '0' + n else n)
    @getFullYear() + '-' +
    pad(@getMonth() + 1) + '-' +
    pad(@getDate()) + 'T' +
    pad(@getHours()) + ':' +
    pad(@getMinutes()) + ':' +
    pad(@getSeconds()) + '.' +
    ms(@getMilliseconds()) + 'Z'

createHAR = (address, title, startTime, resources) ->
  entries = []

  resources.forEach (resource) ->
    request = resource.request
    startReply = resource.startReply
    endReply = resource.endReply

    if not request or not startReply or not endReply
      return

    entries.push
      startedDateTime: request.time.toISOString()
      time: endReply.time - request.time
      request:
        method: request.method
        url: request.url
        httpVersion: 'HTTP/1.1'
        cookies: []
        headers: request.headers
        queryString: []
        headersSize: -1
        bodySize: -1

      response:
        status: endReply.status
        statusText: endReply.statusText
        httpVersion: 'HTTP/1.1'
        cookies: []
        headers: endReply.headers
        redirectURL: ''
        headersSize: -1
        bodySize: startReply.bodySize
        content:
          size: startReply.bodySize
          mimeType: endReply.contentType

      cache: {}
      timings:
        blocked: 0
        dns: -1
        connect: -1
        send: 0
        wait: startReply.time - request.time
        receive: endReply.time - startReply.time
        ssl: -1
      pageref: address

  log:
    version: '1.2'
    creator:
      name: 'PhantomJS'
      version: phantom.version.major + '.' + phantom.version.minor + '.' + phantom.version.patch

    pages: [
      startedDateTime: startTime.toISOString()
      id: address
      title: title
      pageTimings:
        onLoad: page.endTime - page.startTime
    ]
    entries: entries

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: netsniff.coffee <some URL>'
  phantom.exit 1
else
  page.address = system.args[1]
  page.resources = []

  page.onLoadStarted = ->
    page.startTime = new Date()

  page.onResourceRequested = (req) ->
    page.resources[req.id] =
      request: req
      startReply: null
      endReply: null

  page.onResourceReceived = (res) ->
    if res.stage is 'start'
      page.resources[res.id].startReply = res
    if res.stage is 'end'
      page.resources[res.id].endReply = res

  page.open page.address, (status) ->
    if status isnt 'success'
      console.log 'FAIL to load the address'
      phantom.exit(1)
    else
      page.endTime = new Date()
      page.title = page.evaluate ->
        document.title

      har = createHAR page.address, page.title, page.startTime, page.resources
      console.log JSON.stringify har, undefined, 4
      phantom.exit()

helloWorld = () -> console.log phantom.outputEncoding + ": こんにちは、世界！"

console.log "Using default encoding..."
helloWorld()

console.log "\nUsing other encodings..."
for enc in ["euc-jp", "sjis", "utf8", "System"]
  do (enc) ->
    phantom.outputEncoding = enc
    helloWorld()

phantom.exit()

# The purpose of this is to show how and when events fire, considering 5 steps
# happening as follows:
#
#      1. Load URL
#      2. Load same URL, but adding an internal FRAGMENT to it
#      3. Click on an internal Link, that points to another internal FRAGMENT
#      4. Click on an external Link, that will send the page somewhere else
#      5. Close page
#
# Take particular care when going through the output, to understand when
# things happen (and in which order). Particularly, notice what DOESN'T
# happen during step 3.
#
# If invoked with "-v" it will print out the Page Resources as they are
# Requested and Received.
#
# NOTE.1: The "onConsoleMessage/onAlert/onPrompt/onConfirm" events are
# registered but not used here. This is left for you to have fun with.
# NOTE.2: This script is not here to teach you ANY JavaScript. It's aweful!
# NOTE.3: Main audience for this are people new to PhantomJS.
printArgs = ->
  i = undefined
  ilen = undefined
  i = 0
  ilen = arguments_.length

  while i < ilen
    console.log "    arguments[" + i + "] = " + JSON.stringify(arguments_[i])
    ++i
  console.log ""
sys = require("system")
page = require("webpage").create()
logResources = false
step1url = "http://en.wikipedia.org/wiki/DOM_events"
step2url = "http://en.wikipedia.org/wiki/DOM_events#Event_flow"
logResources = true  if sys.args.length > 1 and sys.args[1] is "-v"

#//////////////////////////////////////////////////////////////////////////////
page.onInitialized = ->
  console.log "page.onInitialized"
  printArgs.apply this, arguments_

page.onLoadStarted = ->
  console.log "page.onLoadStarted"
  printArgs.apply this, arguments_

page.onLoadFinished = ->
  console.log "page.onLoadFinished"
  printArgs.apply this, arguments_

page.onUrlChanged = ->
  console.log "page.onUrlChanged"
  printArgs.apply this, arguments_

page.onNavigationRequested = ->
  console.log "page.onNavigationRequested"
  printArgs.apply this, arguments_

if logResources is true
  page.onResourceRequested = ->
    console.log "page.onResourceRequested"
    printArgs.apply this, arguments_

  page.onResourceReceived = ->
    console.log "page.onResourceReceived"
    printArgs.apply this, arguments_
page.onClosing = ->
  console.log "page.onClosing"
  printArgs.apply this, arguments_


# window.console.log(msg);
page.onConsoleMessage = ->
  console.log "page.onConsoleMessage"
  printArgs.apply this, arguments_


# window.alert(msg);
page.onAlert = ->
  console.log "page.onAlert"
  printArgs.apply this, arguments_


# var confirmed = window.confirm(msg);
page.onConfirm = ->
  console.log "page.onConfirm"
  printArgs.apply this, arguments_


# var user_value = window.prompt(msg, default_value);
page.onPrompt = ->
  console.log "page.onPrompt"
  printArgs.apply this, arguments_


#//////////////////////////////////////////////////////////////////////////////
setTimeout (->
  console.log ""
  console.log "### STEP 1: Load '" + step1url + "'"
  page.open step1url
), 0
setTimeout (->
  console.log ""
  console.log "### STEP 2: Load '" + step2url + "' (load same URL plus FRAGMENT)"
  page.open step2url
), 5000
setTimeout (->
  console.log ""
  console.log "### STEP 3: Click on page internal link (aka FRAGMENT)"
  page.evaluate ->
    ev = document.createEvent("MouseEvents")
    ev.initEvent "click", true, true
    document.querySelector("a[href='#Event_object']").dispatchEvent ev

), 10000
setTimeout (->
  console.log ""
  console.log "### STEP 4: Click on page external link"
  page.evaluate ->
    ev = document.createEvent("MouseEvents")
    ev.initEvent "click", true, true
    document.querySelector("a[title='JavaScript']").dispatchEvent ev

), 15000
setTimeout (->
  console.log ""
  console.log "### STEP 5: Close page and shutdown (with a delay)"
  page.close()
  setTimeout (->
    phantom.exit()
  ), 100
), 20000
p = require("webpage").create()

p.onConsoleMessage = (msg) ->
  console.log msg

# Calls to "callPhantom" within the page 'p' arrive here
p.onCallback = (msg) ->
  console.log "Received by the 'phantom' main context: " + msg
  "Hello there, I'm coming to you from the 'phantom' context instead"

p.evaluate ->
  # Return-value of the "onCallback" handler arrive here
  callbackResponse = window.callPhantom "Hello, I'm coming to you from the 'page' context"
  console.log "Received by the 'page' context: " + callbackResponse

phantom.exit()

# Read the Phantom webpage '#intro' element text using jQuery and "includeJs"

page = require('webpage').create()

page.onConsoleMessage = (msg) -> console.log msg

page.open "http://www.phantomjs.org", (status) ->
  if status is "success"
    page.includeJs "http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js", ->
      page.evaluate ->
        console.log "$(\"#intro\").text() -> " + $("#intro").text()
      phantom.exit()


# Find pizza in Mountain View using Yelp

page = require('webpage').create()
url = 'http://lite.yelp.com/search?find_desc=pizza&find_loc=94040&find_submit=Search'

page.open url,
  (status) ->
    if status isnt 'success'
      console.log 'Unable to access network'
    else
      results = page.evaluate ->
        pizza = []
        list = document.querySelectorAll 'address'
        for item in list
          pizza.push(item.innerText)
        return pizza
      console.log results.join('\n')
    phantom.exit()

# Example using HTTP POST operation

page = require('webpage').create()
server = 'http://posttestserver.com/post.php?dump'
data = 'universe=expanding&answer=42'

page.open server, 'post', data, (status) ->
  if status isnt 'success'
    console.log 'Unable to post!'
  else
    console.log page.content
  phantom.exit()

# Example using HTTP POST operation
page = require("webpage").create()
server = require("webserver").create()
system = require("system")
data = "universe=expanding&answer=42"
if system.args.length isnt 2
  console.log "Usage: postserver.js <portnumber>"
  phantom.exit 1
port = system.args[1]
service = server.listen(port, (request, response) ->
  console.log "Request received at " + new Date()
  response.statusCode = 200
  response.headers =
    Cache: "no-cache"
    "Content-Type": "text/plain;charset=utf-8"

  response.write JSON.stringify(request, null, 4)
  response.close()
)
page.open "http://localhost:" + port + "/", "post", data, (status) ->
  if status isnt "success"
    console.log "Unable to post!"
  else
    console.log page.plainText
  phantom.exit()

system = require("system")
env = system.env
key = undefined
for key of env
  console.log key + "=" + env[key]  if env.hasOwnProperty(key)
phantom.exit()
someCallback = (pageNum, numPages) ->
  "<h1> someCallback: " + pageNum + " / " + numPages + "</h1>"
page = require("webpage").create()
system = require("system")
if system.args.length < 3
  console.log "Usage: printheaderfooter.js URL filename"
  phantom.exit 1
else
  address = system.args[1]
  output = system.args[2]
  page.viewportSize =
    width: 600
    height: 600

  page.paperSize =
    format: "A4"
    margin: "1cm"
    
    # default header/footer for pages that don't have custom overwrites (see below) 
    header:
      height: "1cm"
      contents: phantom.callback((pageNum, numPages) ->
        return ""  if pageNum is 1
        "<h1>Header <span style='float:right'>" + pageNum + " / " + numPages + "</span></h1>"
      )

    footer:
      height: "1cm"
      contents: phantom.callback((pageNum, numPages) ->
        return ""  if pageNum is numPages
        "<h1>Footer <span style='float:right'>" + pageNum + " / " + numPages + "</span></h1>"
      )

  page.open address, (status) ->
    if status isnt "success"
      console.log "Unable to load the address!"
    else
      
      # check whether the loaded page overwrites the header/footer setting,
      #               i.e. whether a PhantomJSPriting object exists. Use that then instead
      #               of our defaults above.
      #
      #               example:
      #               <html>
      #                 <head>
      #                   <script type="text/javascript">
      #                     var PhantomJSPrinting = {
      #                        header: {
      #                            height: "1cm",
      #                            contents: function(pageNum, numPages) { return pageNum + "/" + numPages; }
      #                        },
      #                        footer: {
      #                            height: "1cm",
      #                            contents: function(pageNum, numPages) { return pageNum + "/" + numPages; }
      #                        }
      #                     };
      #                   </script>
      #                 </head>
      #                 <body><h1>asdfadsf</h1><p>asdfadsfycvx</p></body>
      #              </html>
      #            
      if page.evaluate(->
        typeof PhantomJSPrinting is "object"
      )
        paperSize = page.paperSize
        paperSize.header.height = page.evaluate(->
          PhantomJSPrinting.header.height
        )
        paperSize.header.contents = phantom.callback((pageNum, numPages) ->
          page.evaluate ((pageNum, numPages) ->
            PhantomJSPrinting.header.contents pageNum, numPages
          ), pageNum, numPages
        )
        paperSize.footer.height = page.evaluate(->
          PhantomJSPrinting.footer.height
        )
        paperSize.footer.contents = phantom.callback((pageNum, numPages) ->
          page.evaluate ((pageNum, numPages) ->
            PhantomJSPrinting.footer.contents pageNum, numPages
          ), pageNum, numPages
        )
        page.paperSize = paperSize
        console.log page.paperSize.header.height
        console.log page.paperSize.footer.height
      window.setTimeout (->
        page.render output
        phantom.exit()
      ), 200

page = require("webpage").create()
system = require("system")
if system.args.length < 7
  console.log "Usage: printmargins.js URL filename LEFT TOP RIGHT BOTTOM"
  console.log "  margin examples: \"1cm\", \"10px\", \"7mm\", \"5in\""
  phantom.exit 1
else
  address = system.args[1]
  output = system.args[2]
  marginLeft = system.args[3]
  marginTop = system.args[4]
  marginRight = system.args[5]
  marginBottom = system.args[6]
  page.viewportSize =
    width: 600
    height: 600

  page.paperSize =
    format: "A4"
    margin:
      left: marginLeft
      top: marginTop
      right: marginRight
      bottom: marginBottom

  page.open address, (status) ->
    if status isnt "success"
      console.log "Unable to load the address!"
    else
      window.setTimeout (->
        page.render output
        phantom.exit()
      ), 200

page = require('webpage').create()
system = require 'system'

if system.args.length < 3 or system.args.length > 4
  console.log 'Usage: rasterize.coffee URL filename [paperwidth*paperheight|paperformat]'
  console.log '  paper (pdf output) examples: "5in*7.5in", "10cm*20cm", "A4", "Letter"'
  phantom.exit 1
else
  address = system.args[1]
  output = system.args[2]
  page.viewportSize = { width: 600, height: 600 }
  if system.args.length is 4 and system.args[2].substr(-4) is ".pdf"
    size = system.args[3].split '*'
    if size.length is 2
      page.paperSize = { width: size[0], height: size[1], border: '0px' }
    else
      page.paperSize = { format: system.args[3], orientation: 'portrait', border: '1cm' }
  page.open address, (status) ->
    if status isnt 'success'
      console.log 'Unable to load the address!'
      phantom.exit()
    else
      window.setTimeout (-> page.render output; phantom.exit()), 200

# Render Multiple URLs to file

system = require("system")

# Render given urls
# @param array of URLs to render
# @param callbackPerUrl Function called after finishing each URL, including the last URL
# @param callbackFinal Function called after finishing everything
RenderUrlsToFile = (urls, callbackPerUrl, callbackFinal) ->
  urlIndex = 0 # only for easy file naming
  webpage = require("webpage")
  page = null
  getFilename = ->
    "rendermulti-" + urlIndex + ".png"

  next = (status, url, file) ->
    page.close()
    callbackPerUrl status, url, file
    retrieve()

  retrieve = ->
    if urls.length > 0
      url = urls.shift()
      urlIndex++
      page = webpage.create()
      page.viewportSize =
        width: 800
        height: 600

      page.settings.userAgent = "Phantom.js bot"
      page.open "http://" + url, (status) ->
        file = getFilename()
        if status is "success"
          window.setTimeout (->
            page.render file
            next status, url, file
          ), 200
        else
          next status, url, file

    else
      callbackFinal()

  retrieve()
arrayOfUrls = null
if system.args.length > 1
  arrayOfUrls = Array::slice.call(system.args, 1)
else
  # Default (no args passed)
  console.log "Usage: phantomjs render_multi_url.js [domain.name1, domain.name2, ...]"
  arrayOfUrls = ["www.google.com", "www.bbc.co.uk", "www.phantomjs.org"]

RenderUrlsToFile arrayOfUrls, ((status, url, file) ->
  if status isnt "success"
    console.log "Unable to render '" + url + "'"
  else
    console.log "Rendered '" + url + "' at '" + file + "'"
), ->
  phantom.exit()


system = require 'system'

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
  start = new Date().getTime()
  condition = false
  f = ->
    if (new Date().getTime() - start < timeOutMillis) and not condition
      # If not time-out yet and condition not yet fulfilled
      condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
    else
      if not condition
        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else
        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in #{new Date().getTime() - start}ms."
        if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
  interval = setInterval f, 100 #< repeat check every 100ms

if system.args.length isnt 2
  console.log 'Usage: run-jasmine.coffee URL'
  phantom.exit 1

page = require('webpage').create()

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg

page.open system.args[1], (status) ->
  if status isnt 'success'
    console.log 'Unable to access network'
    phantom.exit()
  else
    waitFor ->
      page.evaluate ->
        if document.body.querySelector '.finished-at'
          return true
        return false
    , ->
      page.evaluate ->
        console.log document.body.querySelector('.description').innerText
        list = document.body.querySelectorAll('.failed > .description, .failed > .messages > .resultMessage')
        for el in list
          console.log el.innerText

      phantom.exit()

system = require 'system'

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
  start = new Date().getTime()
  condition = false
  f = ->
    if (new Date().getTime() - start < timeOutMillis) and not condition
      # If not time-out yet and condition not yet fulfilled
      condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
    else
      if not condition
        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else
        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in #{new Date().getTime() - start}ms."
        if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
  interval = setInterval f, 100 #< repeat check every 100ms

if system.args.length isnt 2
  console.log 'Usage: run-qunit.coffee URL'
  phantom.exit 1

page = require('webpage').create()

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg

page.open system.args[1], (status) ->
  if status isnt 'success'
    console.log 'Unable to access network'
    phantom.exit 1
  else
    waitFor ->
      page.evaluate ->
        el = document.getElementById 'qunit-testresult'
        if el and el.innerText.match 'completed'
          return true
        return false
    , ->
      failedNum = page.evaluate ->
        el = document.getElementById 'qunit-testresult'
        console.log el.innerText
        try
          return el.getElementsByClassName('failed')[0].innerHTML
        catch e
        return 10000

      phantom.exit if parseInt(failedNum, 10) > 0 then 1 else 0

# List all the files in a Tree of Directories
system = require 'system'

if system.args.length != 2
  console.log "Usage: phantomjs scandir.coffee DIRECTORY_TO_SCAN"
  phantom.exit 1
scanDirectory = (path) ->
  fs = require 'fs'
  if fs.exists(path) and fs.isFile(path)
    console.log path
  else if fs.isDirectory(path)
    fs.list(path).forEach (e) ->
      scanDirectory path + "/" + e  if e != "." and e != ".."

scanDirectory system.args[1]
phantom.exit()

# Show BBC seasonal food list.

window.cbfunc = (data) ->
  list = data.query.results.results.result
  names = ['January', 'February', 'March',
           'April', 'May', 'June',
           'July', 'August', 'September',
           'October', 'November', 'December']
  for item in list
    console.log [item.name.replace(/\s/ig, ' '), ':',
                names[item.atItsBestUntil], 'to',
                names[item.atItsBestFrom]].join(' ')
  phantom.exit()

el = document.createElement 'script'
el.src = 'http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20bbc.goodfood.seasonal%3B&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=window.cbfunc'
document.body.appendChild el

page = require("webpage").create()
server = require("webserver").create()
system = require("system")
host = undefined
port = undefined
if system.args.length isnt 2
  console.log "Usage: server.js <some port>"
  phantom.exit 1
else
  port = system.args[1]
  listening = server.listen(port, (request, response) ->
    console.log "GOT HTTP REQUEST"
    console.log JSON.stringify(request, null, 4)
    
    # we set the headers here
    response.statusCode = 200
    response.headers =
      Cache: "no-cache"
      "Content-Type": "text/html"

    
    # this is also possible:
    response.setHeader "foo", "bar"
    
    # now we write the body
    # note: the headers above will now be sent implictly
    response.write "<html><head><title>YES!</title></head>"
    
    # note: writeBody can be called multiple times
    response.write "<body><p>pretty cool :)</body></html>"
    response.close()
  )
  unless listening
    console.log "could not create web server listening on port " + port
    phantom.exit()
  url = "http://localhost:" + port + "/foo/bar.php?asdf=true"
  console.log "SENDING REQUEST TO:"
  console.log url
  page.open url, (status) ->
    if status isnt "success"
      console.log "FAIL to load the address"
    else
      console.log "GOT REPLY FROM SERVER:"
      console.log page.content
    phantom.exit()

port = undefined
server = undefined
service = undefined
system = require("system")
if system.args.length isnt 2
  console.log "Usage: serverkeepalive.js <portnumber>"
  phantom.exit 1
else
  port = system.args[1]
  server = require("webserver").create()
  service = server.listen(port,
    keepAlive: true
  , (request, response) ->
    console.log "Request at " + new Date()
    console.log JSON.stringify(request, null, 4)
    body = JSON.stringify(request, null, 4)
    response.statusCode = 200
    response.headers =
      Cache: "no-cache"
      "Content-Type": "text/plain"
      Connection: "Keep-Alive"
      "Keep-Alive": "timeout=5, max=100"
      "Content-Length": body.length

    response.write body
    response.close()
  )
  if service
    console.log "Web server running on port " + port
  else
    console.log "Error: Could not create web server listening on port " + port
    phantom.exit()
system = require 'system'

if system.args.length is 1
  console.log "Usage: simpleserver.coffee <portnumber>"
  phantom.exit 1
else
  port = system.args[1]
  server = require("webserver").create()

  service = server.listen(port, (request, response) ->

    console.log "Request at " + new Date()
    console.log JSON.stringify(request, null, 4)

    response.statusCode = 200
    response.headers =
      Cache: "no-cache"
      "Content-Type": "text/html"

    response.write "<html>"
    response.write "<head>"
    response.write "<title>Hello, world!</title>"
    response.write "</head>"
    response.write "<body>"
    response.write "<p>This is from PhantomJS web server.</p>"
    response.write "<p>Request data:</p>"
    response.write "<pre>"
    response.write JSON.stringify(request, null, 4)
    response.write "</pre>"
    response.write "</body>"
    response.write "</html>"
    response.close()
  )
  if service
    console.log "Web server running on port " + port
  else
    console.log "Error: Could not create web server listening on port " + port
    phantom.exit()

###
Sort integers from the command line in a very ridiculous way: leveraging timeouts :P
###

system = require 'system'

if system.args.length < 2
  console.log "Usage: phantomjs sleepsort.coffee PUT YOUR INTEGERS HERE SEPARATED BY SPACES"
  phantom.exit 1
else
  sortedCount = 0
  args = Array.prototype.slice.call(system.args, 1)
  for int in args
    setTimeout (do (int) ->
      ->
        console.log int
        ++sortedCount
        phantom.exit() if sortedCount is args.length),
      int


system = require 'system'

system.stdout.write 'Hello, system.stdout.write!'
system.stdout.writeLine '\nHello, system.stdout.writeLine!'

system.stderr.write 'Hello, system.stderr.write!'
system.stderr.writeLine '\nHello, system.stderr.writeLine!'

system.stdout.writeLine 'system.stdin.readLine(): '
line = system.stdin.readLine()
system.stdout.writeLine JSON.stringify line

# This is essentially a `readAll`
system.stdout.writeLine 'system.stdin.read(5): (ctrl+D to end)'
input = system.stdin.read 5
system.stdout.writeLine JSON.stringify input

phantom.exit 0

page = require('webpage').create()

page.viewportSize = { width: 320, height: 480 }

page.open 'http://news.google.com/news/i/section?&topic=t',
  (status) ->
    if status isnt 'success'
      console.log 'Unable to access the network!'
    else
      page.evaluate ->
        body = document.body
        body.style.backgroundColor = '#fff'
        body.querySelector('div#title-block').style.display = 'none'
        body.querySelector('form#edition-picker-form')
          .parentElement.parentElement.style.display = 'none'
      page.render 'technews.png'
    phantom.exit()

# Get twitter status for given account (or for the default one, "PhantomJS")

page = require('webpage').create()
system = require 'system'
twitterId = 'PhantomJS' #< default value

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg

# Print usage message, if no twitter ID is passed
if system.args.length < 2
  console.log 'Usage: tweets.coffee [twitter ID]'
else
  twitterId = system.args[1]

# Heading
console.log "*** Latest tweets from @#{twitterId} ***\n"

# Open Twitter Mobile and, onPageLoad, do...
page.open encodeURI("http://mobile.twitter.com/#{twitterId}"), (status) ->
  # Check for page load success
  if status isnt 'success'
    console.log 'Unable to access network'
  else
    # Execute some DOM inspection within the page context
    page.evaluate ->
      list = document.querySelectorAll 'div.tweet-text'
      for i, j in list
        console.log "#{j + 1}: #{i.innerText}"
  phantom.exit()

# Modify global object at the page initialization.
# In this example, effectively Math.random() always returns 0.42.

page = require('webpage').create()
page.onInitialized = ->
  page.evaluate ->
    Math.random = ->
      42 / 100

page.open "http://ariya.github.com/js/random/", (status) ->
  if status != "success"
    console.log "Network error."
  else
    console.log page.evaluate(->
      document.getElementById("numbers").textContent
    )
  phantom.exit()


page = require('webpage').create()

console.log 'The default user agent is ' + page.settings.userAgent

page.settings.userAgent = 'SpecialAgent'
page.open 'http://www.httpuseragent.org', (status) ->
  if status isnt 'success'
    console.log 'Unable to access network'
  else
    console.log page.evaluate -> document.getElementById('myagent').innerText
  phantom.exit()

console.log 'using PhantomJS version ' +
            phantom.version.major + '.' +
            phantom.version.minor + '.' +
            phantom.version.patch
phantom.exit()

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
  start = new Date().getTime()
  condition = false
  f = ->
    if (new Date().getTime() - start < timeOutMillis) and not condition
      # If not time-out yet and condition not yet fulfilled
      condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
    else
      if not condition
        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else
        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in #{new Date().getTime() - start}ms."
        if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
  interval = setInterval f, 250 #< repeat check every 250ms


page = require('webpage').create()

# Open Twitter on 'sencha' profile and, onPageLoad, do...
page.open 'http://twitter.com/#!/sencha', (status) ->
  # Check for page load success
  if status isnt 'success'
    console.log 'Unable to access network'
  else
    # Wait for 'signin-dropdown' to be visible
    waitFor ->
      # Check in the page if a specific element is now visible
      page.evaluate ->
        $('#signin-dropdown').is ':visible'
    , ->
       console.log 'The sign-in dialog should be visible now.'
       phantom.exit()

pageTitle = (page) ->
  page.evaluate ->
    window.document.title
setPageTitle = (page, newTitle) ->
  page.evaluate ((newTitle) ->
    window.document.title = newTitle
  ), newTitle
p = require("webpage").create()
p.open "../test/webpage-spec-frames/index.html", (status) ->
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(\"frame1\"): " + p.switchToChildFrame("frame1")
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(\"frame1-2\"): " + p.switchToChildFrame("frame1-2")
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToParentFrame(): " + p.switchToParentFrame()
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(0): " + p.switchToChildFrame(0)
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToMainFrame()"
  p.switchToMainFrame()
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(\"frame2\"): " + p.switchToChildFrame("frame2")
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  phantom.exit()

page = require('webpage').create()
system = require 'system'

city = 'Mountain View, California'; # default
if system.args.length > 1
    city = Array.prototype.slice.call(system.args, 1).join(' ')
url = encodeURI 'http://api.openweathermap.org/data/2.1/find/name?q=' + city

console.log 'Checking weather condition for', city, '...'

page.open url, (status) ->
    if status isnt 'success'
        console.log 'Error: Unable to access network!'
    else
        result = page.evaluate ->
            return document.body.innerText
        try
            data = JSON.parse result
            data = data.list[0]
            console.log ''
            console.log 'City:',  data.name
            console.log 'Condition:', data.weather.map (entry) ->
                return entry.main
            console.log 'Temperature:', Math.round(data.main.temp - 273.15), 'C'
            console.log 'Humidity:', Math.round(data.main.humidity), '%'
        catch e
           console.log 'Error:', e.toString()

    phantom.exit()




window.Tourist = window.Tourist or {}

###
A model for the Tour. We'll only use the 'current_step' property.
###
class Tourist.Model extends Backbone.Model
  _module: 'Tourist'
# Just the tip, just to see how it feels.
window.Tourist.Tip = window.Tourist.Tip or {}


###
The flyout showing the content of each step.

This is the base class containing most of the logic. Can extend for different
tooltip implementations.
###
class Tourist.Tip.Base
	_module: 'Tourist'
	_.extend @prototype, Backbone.Events

	visable: false

	# You can override any of thsee templates for your own stuff
	skipButtonTemplate: '<button class="btn btn-default btn-sm pull-right tour-next">Skip this step →</button>'
	nextButtonTemplate: '<button class="btn btn-primary btn-sm pull-right tour-next">Next step →</button>'
	finalButtonTemplate: '<button class="btn btn-primary btn-sm pull-right tour-next">Finish up</button>'

	closeButtonTemplate: '<a class="btn btn-close tour-close" href="#"><i class="<%= classes %>"></i></a>'
	okButtonTemplate: '<button class="btn btn-sm tour-close btn-primary">Okay</button>'
	coverTemplate: '<div class="<%= classes %>" tabindex="1"></div>'

	actionLabelTemplate: _.template '<h4 class="action-label"><%= label %></h4>'
	actionLabels: ['Do this:', 'Then this:', 'Next this:']

	highlightClass: 'tour-highlight'
	closeButtonClasses: 'icon icon-remove'
	touristCoverClasses: 'tourist-cover'

	addedHightlightClasses: undefined

	template: _.template '''
		<div>
			<div class="tour-container">
				<%= close_button %>
				<%= content %>
				<p class="tour-counter <%= counter_class %>"><%= counter%></p>
			</div>
			<div class="tour-buttons">
				<%= buttons %>
			</div>
		</div>
	'''

	# options -
	#   model - a Tourist.Model object
	constructor: (@options={}) ->
		@el = $('<div/>')

		@initialize(options)

		@cover = $.parseHTML(@coverTemplate)

		@_bindClickEvents()

		Tourist.Tip.Base._cacheTip(this)

	destroy: ->
		@el.remove()
		@cover.remove() if @cover? and @cover.remove?
		
		false

	# Render the current step as specified by the Tour Model
	#
	# step - step object
	#
	# Return this
	render: (step) ->
		@hide()

		if step
			@_setTarget(step.target or false, step)
			@_setZIndex('')
			@_renderContent(step, @_buildContentElement(step))
			@show() if step.target
			@_setZIndex(step.zIndex, step) if step.zIndex

			cover = @_buildCover(step)
			$('body').append(cover) if step.cover?

			@visible = true

		this

	# Show the tip
	show: ->
		@cover.show().addClass('visible') if @cover?
		# Override me

	# Hide the tip
	hide: ->
		@cover.hide().removeClass('visible') if @cover?
		@visable = false
		# Override me

	# Set the element which the tip will point to
	#
	# targetElement - a jquery element
	# step - step object
	setTarget: (targetElement, step) ->
		@_setTarget(targetElement, step)

	# Unhighlight and unset the current target
	cleanupCurrentTarget: ->
		if @target? and @target.removeClass?
			@target.removeClass(@highlightClass)

			if @addedHightlightClasses?
				@target.removeClass(@addedHightlightClasses) 
				@addedHightlightClasses = undefined

		if @cover? 
			$('.tourist-cover').remove()

		@target = null

	###
	Event Handlers
	###

	# User clicked close or ok button
	onClickClose: (event) =>
		@trigger('click:close', this, event)
		false

	# User clicked next or skip button
	onClickNext: (event) =>
		@trigger('click:next', this, event)
		false


	###
	Private
	###

	# Returns the jquery element that contains all the tip data.
	_getTipElement: ->
		# Override me

	# Place content into your tip's body. Called in render()
	#
	# step - the step object for the current step
	# contentElement - a jquery element containing all the tip's content
	#
	# Returns nothing
	_renderContent: (step, contentElement) ->
		# Override me

	# Bind to the buttons
	_bindClickEvents: ->
		el = @_getTipElement()
		el.delegate('.tour-close', 'click', @onClickClose)
		el.delegate('.tour-next', 'click', @onClickNext)


		that = @

		cont = $('body')

		cont.keyup (e) ->

			visable = el.is(":visible"); 

			key = e.which

			if e.target.nodeName != 'INPUT' and e.target.nodeName != 'TEXTAREA'

				if visable
					if key == 39 # Right 
						that.onClickNext()
					else if key == 27 # esc
						that.onClickClose()

					if key == 39 or key == 27 
						e.preventDefault()

			false

	# Set the current target
	#
	# target - a jquery element that this flyout should point to.
	# step - step object
	#
	# Return nothing
	_setTarget: (target, step) ->
		@cleanupCurrentTarget()

		if target and step and step.highlightTarget
			target.addClass(@highlightClass)
			
			if step.highlightClass?

				@addedHightlightClasses = step.highlightClass

				target.addClass(step.highlightClass)

		@target = target

	# Set z-index on the tip element.
	#
	# zIndex - the z-index desired; falsy val will clear it.
	_setZIndex: (zIndex) ->
		el = @_getTipElement()
		el.css('z-index', zIndex or '')

	# Will build the element that has all the content for the current step
	#
	# step - the step object for the current step
	#
	# Returns a jquery object with all the content.
	_buildContentElement: (step) ->
		buttons = @_buildButtons(step)

		content = $($.parseHTML(@template(
			content: step.content
			buttons: buttons
			close_button: @_buildCloseButton(step)
			counter: if step.final then '' else "step #{step.index+1} of #{step.total}"
			counter_class: if step.final then 'final' else ''
		)))
		content.find('.tour-buttons').addClass('no-buttons') unless buttons

		@_renderActionLabels(content)

		content

	# Create buttons based on step options.
	#
	# Returns a string of button html to be placed into the template.
	_buildButtons: (step) ->
		buttons = ''

		buttons += @okButtonTemplate if step.okButton
		buttons += @skipButtonTemplate if step.skipButton

		if step.nextButton
			buttons += if step.final then @finalButtonTemplate else @nextButtonTemplate

		buttons

	_buildCloseButton: (step) ->

		closeButton = @closeButtonTemplate

		closeClass = @closeButtonClasses

		closeClass += ' ' + step.closeButtonClass if step.closeButtonClass

		closeButton = closeButton.replace /<%= classes %>/, closeClass

		if step.closeButton then closeButton else ''

	_buildCover: (step) ->

		coverDiv = @coverTemplate

		coverClass = @touristCoverClasses

		coverClass += ' ' + step.coverClass if step.coverClass

		coverDiv = coverDiv.replace /<%= classes %>/, coverClass

		if step.cover then coverDiv else ''


	_renderActionLabels: (el) ->
		actions = el.find('.action')
		actionIndex = 0
		for action in actions
			label = $($.parseHTML(@actionLabelTemplate(label: @actionLabels[actionIndex])))
			label.insertBefore(action)
			actionIndex++

	# Caches this tip for destroying it later.
	@_cacheTip: (tip) ->
		Tourist.Tip.Base._cachedTips = [] unless Tourist.Tip.Base._cachedTips
		Tourist.Tip.Base._cachedTips.push(tip)

	# Destroy all tips. Useful in tests.
	@destroy: ->
		return unless Tourist.Tip.Base._cachedTips
		for tip in Tourist.Tip.Base._cachedTips
			tip.destroy()
		Tourist.Tip.Base._cachedTips = null


###
Bootstrap based tip implementation
###
class Tourist.Tip.Bootstrap extends Tourist.Tip.Base

  initialize: (options) ->
    defs =
      showEffect: null
      hideEffect: null
    @options = _.extend(defs, options)
    @tip = new Tourist.Tip.BootstrapTip(@options)

  destroy: ->
    @tip.destroy()
    super()

  # Show the tip
  show: ->
    if @options.showEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.showEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.show()

  # Hide the tip
  hide: ->
    if @options.hideEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.hideEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.hide()


  ###
  Private
  ###

  # Overridden to get the bootstrap element
  _getTipElement: ->
    @tip.el

  # Set the current target. Overridden to set the target on the tip.
  #
  # target - a jquery element that this flyout should point to.
  # step - step object
  #
  # Return nothing
  _setTarget: (target, step) ->
    super(target, step)
    @tip.setTarget(target)

  # Jam the content into the tip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->
    my = step.my or 'left center'
    at = step.at or 'right center'

    @tip.setContainer(step.container or $('body'))
    @tip.setContent(contentElement)
    @tip.setPosition(step.target or false, my, at)


# One can add more effects by hanging a function from this object, then using
# it in the tipOptions.hideEffect or showEffect. i.e.
#
# @s = new Tourist.Tip.Bootstrap
#   model: m
#   showEffect: 'slidein'
#
Tourist.Tip.Bootstrap.effects =

  # Move tip away from target 80px, then slide it in.
  slidein: (tip, element) ->
    OFFSETS = top: 80, left: 80, right: -80, bottom: -80

    # this is a 'Corner' object. Will give us a top, bottom, etc
    side = tip.my.split(' ')[0]
    side = side or 'top'

    # figure out where to start the animation from
    offset = OFFSETS[side]

    # side must be top or left.
    side = 'top' if side == 'bottom'
    side = 'left' if side == 'right'

    value = parseInt(element.css(side))

    # stop the previous animation
    element.stop()

    # set initial position
    css = {}
    css[side] = value + offset
    element.css(css)
    element.show()

    css[side] = value

    # if they have jquery ui, then use a fancy easing. Otherwise, use a builtin.
    easings = ['easeOutCubic', 'swing', 'linear']
    for easing in easings
      break if $.easing[easing]

    element.animate(css, 300, easing)
    null


###
Simple implementation of tooltip with bootstrap markup.

Almost entirely deals with positioning. Uses the similar method for
positioning as qtip2:

  my: 'top center'
  at: 'bottom center'

###
class Tourist.Tip.BootstrapTip

  template: '''
    <div class="popover tourist-popover">
      <div class="arrow"></div>
      <div class="popover-content"></div>
    </div>
  '''

  FLIP_POSITION:
    bottom: 'top'
    top: 'bottom'
    left: 'right'
    right: 'left'

  constructor: (options) ->
    defs =
      offset: 10
      tipOffset: 10
    @options = _.extend(defs, options)
    @el = $($.parseHTML(@template))
    @hide()

  destroy: ->
    @el.remove()

  show: ->
    @el.show().addClass('visible')

  hide: ->
    @el.hide().removeClass('visible')

  setTarget: (@target) ->
    @_setPosition(@target, @my, @at)

  setPosition: (@target, @my, @at) ->
    @_setPosition(@target, @my, @at)

  setContainer: (container) ->
    container.append(@el)

  setContent: (content) ->
    @_getContentElement().html(content)

  ###
  Private
  ###

  _getContentElement: ->
    @el.find('.popover-content')

  _getTipElement: ->
    @el.find('.arrow')

  # Sets the target and the relationship of the tip to the project.
  #
  # target - target node as a jquery element
  # my - position of the tip e.g. 'top center'
  # at - where to point to the target e.g. 'bottom center'
  _setPosition: (target, my='left center', at='right center') ->
    return unless target

    [clas, shift] = my.split(' ')

    originalDisplay = @el.css('display')

    @el
      .css({ top: 0, left: 0, margin: 0, display: 'table' })
      .removeClass('top').removeClass('bottom')
      .removeClass('left').removeClass('right')
      .addClass(@FLIP_POSITION[clas])

    return unless target

    # unset any old tip positioning
    tip = @_getTipElement().css
      left: ''
      right: ''
      top: ''
      bottom: ''

    if shift != 'center'
      tipOffset =
        left: tip[0].offsetWidth/2
        right: 0
        top: tip[0].offsetHeight/2
        bottom: 0

      css = {}
      css[shift] = tipOffset[shift] + @options.tipOffset
      css[@FLIP_POSITION[shift]] = 'auto'
      tip.css(css)

    targetPosition = @_caculateTargetPosition(at, target)
    tipPosition = @_caculateTipPosition(my, targetPosition)
    position = @_adjustForArrow(my, tipPosition)

    @el.css(position)

    # reset the display so we dont inadvertantly show the tip
    @el.css(display: originalDisplay)

  # Figure out where we need to point to on the target element.
  #
  # myPosition - position string on the target. e.g. 'top left'
  # target - target as a jquery element or an array of coords. i.e. [10,30]
  #
  # returns an object with top and left attrs
  _caculateTargetPosition: (atPosition, target) ->

    if Object.prototype.toString.call(target) == '[object Array]'
      return {left: target[0], top: target[1]}

    bounds = @_getTargetBounds(target)
    pos = @_lookupPosition(atPosition, bounds.width, bounds.height)

    return {
      left: bounds.left + pos[0]
      top: bounds.top + pos[1]
    }

  # Position the tip itself to be at the right place in relation to the
  # targetPosition.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # targetPosition - where to point to on the target element. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _caculateTipPosition: (myPosition, targetPosition) ->
    width = @el[0].offsetWidth
    height = @el[0].offsetHeight
    pos = @_lookupPosition(myPosition, width, height)

    return {
      left: targetPosition.left - pos[0]
      top: targetPosition.top - pos[1]
    }

  # Just adjust the tip position to make way for the arrow.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # tipPosition - proper position for the whole tip. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _adjustForArrow: (myPosition, tipPosition) ->
    [clas, shift] = myPosition.split(' ') # will be top, left, right, or bottom

    tip = @_getTipElement()
    width = tip[0].offsetWidth
    height = tip[0].offsetHeight

    position =
      top: tipPosition.top
      left: tipPosition.left

    # adjust the main direction
    switch clas
      when 'top'
        position.top += height+@options.offset
      when 'bottom'
        position.top -= height+@options.offset
      when 'left'
        position.left += width+@options.offset
      when 'right'
        position.left -= width+@options.offset

    # shift the tip
    switch shift
      when 'left'
        position.left -= width/2+@options.tipOffset
      when 'right'
        position.left += width/2+@options.tipOffset
      when 'top'
        position.top -= height/2+@options.tipOffset
      when 'bottom'
        position.top += height/2+@options.tipOffset

    position

  # Figure out how much to shift based on the position string
  #
  # position - position string like 'top left'
  # width - width of the thing
  # height - height of the thing
  #
  # returns a list: [left, top]
  _lookupPosition: (position, width, height) ->
    width2 = width/2
    height2 = height/2

    posLookup =
      'top left': [0,0]
      'left top': [0,0]
      'top right': [width,0]
      'right top': [width,0]
      'bottom left': [0,height]
      'left bottom': [0,height]
      'bottom right': [width,height]
      'right bottom': [width,height]

      'top center': [width2,0]
      'left center': [0,height2]
      'right center': [width,height2]
      'bottom center': [width2,height]

    posLookup[position]

  # Returns the boundaries of the target element
  #
  # target - a jquery element
  _getTargetBounds: (target) ->
    el = target[0]

    if typeof el.getBoundingClientRect == 'function'
      size = el.getBoundingClientRect()
    else
      size =
        width: el.offsetWidth
        height: el.offsetHeight

    $.extend({}, size, target.offset())



###
Qtip based tip implementation
###
class Tourist.Tip.QTip extends Tourist.Tip.Base

  TIP_WIDTH = 6
  TIP_HEIGHT = 14
  ADJUST = 10

  OFFSETS =
    top: 80
    left: 80
    right: -80
    bottom: -80

  # defaults for the qtip flyout.
  QTIP_DEFAULTS:
    content:
      text: ' '
    show:
      ready: false
      delay: 0
      effect: (qtip) ->
        el = $(this)

        # this is a 'Corner' object. Will give us a top, bottom, etc
        side = qtip.options.position.my
        side = side[side.precedance] if side
        side = side or 'top'

        # figure out where to start the animation from
        offset = OFFSETS[side]

        # side must be top or left.
        side = 'top' if side == 'bottom'
        side = 'left' if side == 'right'

        value = parseInt(el.css(side))

        # set initial position
        css = {}
        css[side] = value + offset
        el.css(css)
        el.show()

        css[side] = value
        el.animate(css, 300, 'easeOutCubic')
        null

      autofocus: false
    hide:
      event: null
      delay: 0
      effect: false
    position:
      # set target
      # set viewport to viewport
      adjust:
        method: 'shift shift'
        scroll: false
    style:
      classes: 'ui-tour-tip',
      tip:
        height: TIP_WIDTH,
        width: TIP_HEIGHT
    events: {}
    zindex: 2000

  # Options support everything qtip supports.
  initialize: (options) ->
    options = $.extend(true, {}, @QTIP_DEFAULTS, options)
    @el.qtip(options)
    @qtip = @el.qtip('api')
    @qtip.render()

  destroy: ->
    @qtip.destroy() if @qtip
    super()

  # Show the tip
  show: ->
    @qtip.show()

  # Hide the tip
  hide: ->
    @qtip.hide()


  ###
  Private
  ###

  # Overridden to get the qtip element
  _getTipElement: ->
    $('#qtip-'+@qtip.id)

  # Override to set the target on the qtip
  _setTarget: (targetElement, step) ->
    super(targetElement, step)
    @qtip.set('position.target', targetElement or false)

  # Jam the content into the qtip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->

    my = step.my or 'left center'
    at = step.at or 'right center'

    @_adjustPlacement(my, at)

    @qtip.set('content.text', contentElement)
    @qtip.set('position.container', step.container or $('body'))
    @qtip.set('position.my', my)
    @qtip.set('position.at', at)

    # viewport should be set before target.
    @qtip.set('position.viewport', step.viewport or false)
    @qtip.set('position.target', step.target or false)

    setTimeout( =>
      @_renderTipBackground(my.split(' ')[0])
    , 10)

  # Adjust the placement of the flyout based on its positioning relative to
  # the target. Tip placement and position adjustment is unhandled by qtip. It
  # does provide settings for adjustment, so we use those.
  #
  # my - string like 'top center'. Position of the tip on the flyout.
  # at - string like 'top center'. Place where the tip points on the target.
  #
  # Return nothing
  _adjustPlacement: (my, at) ->
    # issue is that when tip is on left, it needs to be taller than wide, but
    # when on top it should be wider than tall. We're accounting for this
    # here.

    if my.indexOf('top') == 0
      @_adjust(0, ADJUST)

    else if my.indexOf('bottom') == 0
      @_adjust(0, -ADJUST)

    else if my.indexOf('right') == 0
      @_adjust(-ADJUST, 0)

    else
      @_adjust(ADJUST, 0)

  # Set the qtip style properties for tip size and offset.
  _adjust: (adjustX, adjusty) ->
    @qtip.set('position.adjust.x', adjustX)
    @qtip.set('position.adjust.y', adjusty)

  # Add an icon for the tip. Their canvas tips suck. This way we can have a
  # shadow on the tip.
  #
  # direction - string like 'left', 'top', etc. Placement of the tip.
  #
  # Return Nothing
  _renderTipBackground: (direction) =>
    el = $('#qtip-'+@qtip.id+' .qtip-tip')
    bg = el.find('.qtip-tip-bg')
    unless bg.length
      bg = $('<div/>', {'class': 'icon icon-tip qtip-tip-bg'})
      el.append(bg)

    bg.removeClass('top left right bottom')
    bg.addClass(direction)

###
Simplest implementation of a tooltip. Used in the tests. Useful as an example
as well.
###
class Tourist.Tip.Simple extends Tourist.Tip.Base
  initialize: (options) ->
    $('body').append(@el)

  # Show the tip
  show: ->
    @el.show()

  # Hide the tip
  hide: ->
    @el.hide()

  _getTipElement: ->
    @el

  # Jam the content into our element
  _renderContent: (step, contentElement) ->
    @el.html(contentElement)
###

A way to make a tour. Basically, you specify a series of steps which explain
elements to point at and what to say. This class manages moving between those
steps.

The 'step object' is a simple js obj that specifies how the step will behave.

A simple Example of a step object:
  {
    content: '<p>Welcome to my step</p>'
    target: $('#something-to-point-at')
    closeButton: true
    highlightTarget: true
    setup: (tour, options) ->
      # do stuff in the interface/bind
    teardown: (tour, options) ->
      # remove stuff/unbind
  }

Basic Step object options:

  content - a string of html to put into the step.
  target - jquery object or absolute point: [10, 30]
  highlightTarget - optional bool, true will outline the target with a bright color.
  container - optional jquery element that should contain the step flyout.
              default: $('body')
  viewport - optional jquery element that the step flyout should stay within.
             $(window) is commonly used. default: false

  my - string position of the pointer on the tip. default: 'left center'
  at - string position on the element the tip points to. default: 'right center'
  see http://craigsworks.com/projects/qtip2/docs/position/#basics

Step object button options:

  okButton - optional bool, true will show a red ok button
  closeButton - optional bool, true will show a grey close button
  skipButton - optional bool, true will show a grey skip button
  nextButton - optional bool, true will show a red next button

Step object function options:

  All functions on the step will have the signature '(tour, options) ->'

    tour - the Draw.Tour object. Handy to call tour.next()
    options - the step options. An object passed into the tour when created.
              It has the environment that the fns can use to manipulate the
              interface, bind to events, etc. The same object is passed to all
              of a step object's functions, so it is handy for passing data
              between steps.

  setup - called before step is shown. Use to scroll to your target, hide/show things, ...

    'this' is the step object itself.

    MUST return an object. Properties in the returned object will override
    properties in the step object.

    i.e. the target might be dynamic so you would specify:

    setup: (tour, options) ->
      return { target: $('#point-to-me') }

  teardown - function called right before hiding the step. Use to unbind from
    things you bound to in setup().

    'this' is the step object itself.

    Return nothing.

  bind - an array of function names to bind. Use this for event handlers you use in setup().

    Will bind functions to the step object as this, and the first 2 args as tour and options.

    i.e.

    bind: ['onChangeSomething']
    setup: (tour, options) ->
      options.document.bind('change:something', @onChangeSomething)
    onChangeSomething: (tour, options, model, value) ->
      tour.next()
    teardown: (tour, options) ->
      options.document.unbind('change:something', @onChangeSomething)

###
class Tourist.Tour
  _.extend(@prototype, Backbone.Events)

  # options - tour options
  #   stepOptions - an object of options to be passed to each function called on a step object
  #   tipClass - the class from the Tourist.Tip namespace to use
  #   tipOptions - an object passed to the tip
  #   steps - array of step objects
  #   cancelStep - step object for a step that runs if hit the close button.
  #   successStep - step object for a step that runs last when they make it all the way through.
  constructor: (@options={}) ->
    defs =
      tipClass: 'Bootstrap'
    @options = _.extend(defs, @options)

    @model = new Tourist.Model
      current_step: null

    # there is only one tooltip. It will rerender for each step
    tipOptions = _.extend({model: @model}, @options.tipOptions)
    @view = new Tourist.Tip[@options.tipClass](tipOptions)

    @view.bind('click:close', _.bind(@stop, this, true))
    @view.bind('click:next', @next)

    @model.bind('change:current_step', @onChangeCurrentStep)


  ###
  Public
  ###

  # Starts the tour
  #
  # Return nothing
  start: ->
    @trigger('start', this)
    @next()

  # Resets the data and runs the final step
  #
  # doFinalStep - bool whether or not you want to run the final step
  #
  # Return nothing
  stop: (doFinalStep) ->
    if doFinalStep
      @_showCancelFinalStep()
    else
      @_stop()

  # Move to the next step
  #
  # Return nothing
  next: =>
    currentStep = @_teardownCurrentStep()

    index = 0
    index = currentStep.index+1 if currentStep

    if index < @options.steps.length
      @_showStep(@options.steps[index], index)
    else if index == @options.steps.length
      @_showSuccessFinalStep()
    else
      @_stop()

  # Set the stepOptions which is basically like the state for the tour.
  setStepOptions: (stepOptions) ->
    @options.stepOptions = stepOptions


  ###
  Handlers
  ###

  # Called when the current step changes on the model.
  onChangeCurrentStep: (model, step) =>
    @view.render(step)

  ###
  Private
  ###

  # Show the cancel final step - they closed it at some point.
  #
  # Return nothing
  _showCancelFinalStep: ->
    @_showFinalStep(false)

  # Show the success final step - they made it all the way through.
  #
  # Return nothing
  _showSuccessFinalStep: ->
    @_showFinalStep(true)

  # Teardown the current step.
  #
  # Returns the current step after teardown
  _teardownCurrentStep: ->
    currentStep = @model.get('current_step')
    @_teardownStep(currentStep)
    currentStep

  # Stop the tour and reset the state.
  #
  # Return nothing
  _stop: ->
    @_teardownCurrentStep()
    @model.set(current_step: null)
    @trigger('stop', this)

  # Shows a final step.
  #
  # success - bool whether or not to show the success final step. False shows
  #   the cancel final step.
  #
  # Return nothing
  _showFinalStep: (success) ->

    currentStep = @_teardownCurrentStep()

    finalStep = if success then @options.successStep else @options.cancelStep

    if _.isFunction(finalStep)
      finalStep.call(this, this, @options.stepOptions)
      finalStep = null

    return @_stop() unless finalStep
    return @_stop() if currentStep and currentStep.final

    finalStep.final = true
    @_showStep(finalStep, @options.steps.length)

  # Sets step to the current_step in our model. Does all the neccessary setup.
  #
  # step - a step object
  # index - int indexof the step 0 based.
  #
  # Return nothing
  _showStep: (step, index) ->
    return unless step

    step = _.clone(step)
    step.index = index
    step.total = @options.steps.length

    unless step.final
      step.final = (@options.steps.length == index+1 and not @options.successStep)

    # can pass dynamic options from setup
    step = _.extend(step, @_setupStep(step))

    @model.set(current_step: step)

  # Setup an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Returns the return value from step.setup. This will be an object with
  # properties that will override those in the current step object
  _setupStep: (step) ->
    return {} unless step and step.setup

    # bind to any handlers on the step object
    if step.bind
      for fn in step.bind
        step[fn] = _.bind(step[fn], step, this, @options.stepOptions)

    step.setup.call(step, this, @options.stepOptions) or {}

  # Teardown an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Return nothing
  _teardownStep: (step) ->
    step.teardown.call(step, this, @options.stepOptions) if step and step.teardown
    @view.cleanupCurrentTarget()

jasmine.getFixtures().fixturesPath = 'test/fixtures'
jasmine.getStyleFixtures().fixturesPath = 'test/fixtures'

beforeEach ->
  @addMatchers
    toShow: (exp) ->
      actual = this.actual
      actual.css('display') != 'none'

    toHide: (exp) ->
      actual = this.actual
      actual.css('display') == 'none'

window.BasicTipTests = (description, tipGenerator) ->
  describe "Tourist.Tip #{description}", ->
    beforeEach ->
      loadFixtures('tour.html')

      @model = new Tourist.Model
        current_step: null

      @s = tipGenerator.call(this)

    afterEach ->
      Tourist.Tip.Base.destroy()

    describe 'basics', ->
      it 'inits', ->
        expect(@s.options.model instanceof Tourist.Model).toEqual(true)

    describe 'setTarget()', ->
      it 'will set the @target', ->
        el = $('#target-one')
        @s.setTarget(el, {})
        expect(@s.target).toEqual(el)

      it 'will highlight the @target', ->
        el = $('#target-one')
        @s.setTarget(el, {highlightTarget: true})
        expect(el).toHaveClass(@s.highlightClass)

      it 'will highlight the @target', ->
        el = $('#target-one')
        @s.setTarget(el, {highlightTarget: false})
        expect(el).not.toHaveClass(@s.highlightClass)


BasicTipTests 'with Tourist.Tip.Simple', ->
  new Tourist.Tip.Simple
    model: @model


BasicTipTests 'with Tourist.Tip.Bootstrap', ->
  new Tourist.Tip.Bootstrap
    model: @model

BasicTourTests 'with Tourist.Tip.Bootstrap', ->
  new Tourist.Tour
    stepOptions: @options
    steps: @steps
    cancelStep: @finalQuit
    successStep: @finalSucceed
    tipClass: 'Bootstrap'

describe "Tourist.Tip.Bootstrap", ->
  beforeEach ->
    loadFixtures('tour.html')

    @model = new Tourist.Model()
    @s = new Tourist.Tip.Bootstrap
      model: @model

  afterEach ->
    @s.destroy()

  describe 'hide/show', ->
    it 'slidein effect runs', ->
      spyOn(Tourist.Tip.Bootstrap.effects, 'slidein').andCallThrough()
      @s.options.showEffect = 'slidein'
      el = $('#target-one')
      @s.tip.setPosition(el, 'top center', 'bottom center')
      @s.show()
      expect(Tourist.Tip.Bootstrap.effects.slidein).toHaveBeenCalled()

    it 'show works with an effect', ->
      Tourist.Tip.Bootstrap.effects.showeff = jasmine.createSpy()

      @s.options.showEffect = 'showeff'
      @s.show()

      expect(Tourist.Tip.Bootstrap.effects.showeff).toHaveBeenCalled()

    it 'hide works with an effect', ->
      Tourist.Tip.Bootstrap.effects.hideeff = jasmine.createSpy()

      @s.options.hideEffect = 'hideeff'
      @s.hide()

      expect(Tourist.Tip.Bootstrap.effects.hideeff).toHaveBeenCalled()

  describe 'setTarget', ->
    it 'setPosition will not show the tip', ->

      el = $('#target-one')
      @s.tip.setPosition(el, 'top center', 'bottom center')

      spyOn(@s.tip, '_setPosition')

      @s.setTarget([10,20], {})

      expect(@s.tip._setPosition).toHaveBeenCalledWith([10,20], 'top center', 'bottom center')

# Only test the basic things here. Positioning of the popover and the arrow is
# hard to test in code. There is an html file in examples/bootstrap-position-
# test.html to test all the positions.
describe "Tourist.Tip.BootstrapTip", ->
  beforeEach ->
    loadFixtures('tour.html')

    @s = new Tourist.Tip.BootstrapTip()

  afterEach ->
    @s.destroy()

  describe 'hide/show', ->
    it 'initially hidden', ->
      expect(@s.el).toHide()

    it 'hide works', ->
      @s.show()
      @s.hide()
      expect(@s.el).toHide()

    it 'show works', ->
      @s.show()
      expect(@s.el).toShow()

  describe 'positioning', ->
    it 'setPosition will not show the tip', ->
      expect(@s.el).toHide()

      el = $('#target-one')
      @s.setPosition(el, 'top center', 'bottom center')

      expect(@s.el).toHide()

    it 'setPosition keeps the tip shown', ->
      @s.show()

      el = $('#target-one')
      @s.setPosition(el, 'top center', 'bottom center')

      expect(@s.el).toShow()

    it 'setPosition handles an absolute point', ->
      @s.show()

      @s.setPosition([20, 30], 'top left', null)

      expect(@s.el.css('top')).toEqual('40px')
      expect(@s.el.css('left')).toEqual('10px')

BasicTipTests 'with Tourist.Tip.QTip', ->
  new Tourist.Tip.QTip
    model: @model
    content:
      text: '.'

BasicTourTests 'with Tourist.Tip.QTip', ->
  new Tourist.Tour
    stepOptions: @options
    steps: @steps
    cancelStep: @finalQuit
    successStep: @finalSucceed
    tipClass: 'QTip'
    tipOptions:
      content:
        text: '.'

describe "Tourist.Tip.QTip specific", ->
  beforeEach ->
    loadFixtures('tour.html')

    @model = new Tourist.Model
      current_step: null

    @s = new Tourist.Tip.QTip
      model: @model
      content:
        text: '.'

  afterEach ->
    Tourist.Tip.Base.destroy()

  describe 'setTarget()', ->
    it 'will set the @target', ->
      el = $('#target-one')
      @s.setTarget(el, {})

      target = @s.qtip.get('position.target')
      expect(target).toEqual(el)

window.BasicTourTests = (description, tourGenerator) ->
  describe "Tourist.Tour #{description}", ->
    beforeEach ->
      loadFixtures('tour.html')

      @options =
        this: 1
        that: 34

      @steps = [{
        content: '''
          <p class="one">One</p>
        '''
        target: $('#target-one')
        highlightTarget: true
        closeButton: true
        nextButton: true
        setup: (tour, options) ->
        teardown: ->
      },{
        content: '''
          <p class="two">Step Two</p>
        '''
        closeButton: true
        skipButton: true
        setup: ->
          {target: $('#target-two')}
        teardown: ->
      },{
        content: '''
          <p class="three action">Step Three</p>
        '''
        closeButton: true
        nextButton: true
        setup: ->
        teardown: ->
      }]

      @finalQuit =
        content: '''
          <p class="finalquit">The user quit early</p>
        '''
        okButton: true
        target: $('#target-one')
        setup: ->
        teardown: ->

      @finalSucceed =
        content: '''
          <p class="finalsuccess">User made it all the way through</p>
        '''
        okButton: true
        target: $('#target-one')
        setup: ->
        teardown: ->

      @s = tourGenerator.call(this)

    afterEach ->
      Tourist.Tip.Base.destroy()

    describe 'basics', ->
      it 'inits', ->
        expect(@s.model instanceof Tourist.Model).toEqual(true)
        expect(@s.view instanceof Tourist.Tip[@s.options.tipClass]).toEqual(true)

    describe 'rendering', ->
      it 'starts and updates the view', ->
        @s.start()
        @s.next()
        @s.next()

        el = @s.view._getTipElement()
        expect(el.find('.action')).toExist()
        expect(el.find('.action-label')).toExist()
        expect(el.find('.action-label').text()).toEqual('Do this:')

    describe 'zIndex parameter', ->
      it 'uses specified z-index', ->
        @steps[0].zIndex = 4000
        @s.start()
        el = @s.view._getTipElement()
        expect(el.attr('style')).toContain('z-index: 4000')

      it 'clears z-index when not specified', ->
        @steps[0].zIndex = 4000
        @s.start()
        @s.next()
        el = @s.view._getTipElement()
        expect(el.attr('style')).not.toContain('z-index: 4000')

    describe 'stepping', ->
      it 'starts and updates the model', ->
        expect(@s.model.get('current_step')).toEqual(null)

        @s.start()

        expect(@s.model.get('current_step')).not.toEqual(null)
        expect(@s.model.get('current_step').index).toEqual(0)

      it 'starts and updates the view', ->
        @s.start()
        el = @s.view._getTipElement()
        expect(el).toShow()
        expect(el.find('.one')).toExist()
        expect(el.find('.two')).not.toExist()

        expect(el.find('.tour-counter').text()).toEqual('step 1 of 3')

      it 'calls setup', ->
        spyOn(@steps[0], 'setup')

        @s.start()

        expect(@steps[0].setup).toHaveBeenCalledWith(@s, @options)

      it 'calls teardown', ->
        spyOn(@steps[0], 'teardown')
        spyOn(@steps[1], 'setup')

        @s.start()
        @s.next()

        expect(@steps[0].teardown).toHaveBeenCalledWith(@s, @options)
        expect(@steps[1].setup).toHaveBeenCalledWith(@s, @options)

      it 'moves to the next step', ->
        @s.start()
        @s.next()

        expect(@s.model.get('current_step').index).toEqual(1)

        el = @s.view._getTipElement()
        expect(el).toShow()
        expect(el.find('.one')).not.toExist()
        expect(el.find('.two')).toExist()

      it 'calls the final step when through all steps', ->
        @s.start()
        @s.next()
        @s.next()
        expect(@s.model.get('current_step').final).toEqual(false)

        @s.next()
        expect(@s.model.get('current_step').index).toEqual(3)
        expect(@s.model.get('current_step').final).toEqual(true)

        el = @s.view._getTipElement()
        expect(el).toShow()
        expect(el.find('.three')).not.toExist()
        expect(el.find('.finalsuccess')).toExist()

      it 'last step is final when no successStep', ->
        @s.options.successStep = null

        @s.start()
        @s.next()
        @s.next()

        expect(@s.model.get('current_step').index).toEqual(2)
        expect(@s.model.get('current_step').final).toEqual(true)

      it 'calls the function when successStep is just a function', ->
        callback = jasmine.createSpy()
        @s.options.successStep = callback

        @s.start()
        @s.next()
        @s.next()
        @s.next()

        expect(callback).toHaveBeenCalled()

      it 'stops after the final step', ->
        @s.start()
        @s.next()
        @s.next()
        @s.next()
        @s.next()

        expect(@s.model.get('current_step')).toEqual(null)

        el = @s.view._getTipElement()
        #expect(el).toHide() # no worky in qtip tests. Works in real life.

      it 'targets an element returned from setup', ->
        @s.start()
        @s.next()

        expect(@s.view.target[0]).toEqual($('#target-two')[0])

      it 'highlights and unhighlights when neccessary', ->
        @s.start()

        expect($('#target-one')).toHaveClass('tour-highlight')

        @s.next()

        expect($('#target-two')).not.toHaveClass('tour-highlight')
        expect($('#target-one')).not.toHaveClass('tour-highlight')

    describe 'stop()', ->
      it 'pops final cancel step when I pass it true', ->
        @s.start()
        @s.next()
        @s.stop(true)

        expect(@s.model.get('current_step').final).toEqual(true)

        el = @s.view._getTipElement()
        expect(el.find('.finalquit')).toExist()

      it 'actually stops when I pass falsy value', ->
        @s.start()
        @s.next()
        @s.stop()

        expect(@s.model.get('current_step')).toEqual(null)

      it 'unhighlights current thing', ->
        @s.start()
        @s.stop()
        expect(@s.model.get('current_step')).toEqual(null)
        expect($('#target-one')).not.toHaveClass('tour-highlight')

      it 'called when final step open will really stop', ->
        @s.start()
        @s.next()
        @s.stop(true)
        @s.stop(true)

        expect(@s.model.get('current_step')).toEqual(null)

      it 'handles case when no final step', ->
        @s.options.cancelStep = null

        @s.start()
        @s.next()
        @s.stop(true)

        expect(@s.model.get('current_step')).toEqual(null)

      it 'calls teardown on step before final', ->
        spyOn(@steps[1], 'teardown')
        spyOn(@finalQuit, 'setup')

        @s.start()
        @s.next()
        @s.stop(true)

        expect(@steps[1].teardown).toHaveBeenCalledWith(@s, @options)
        expect(@finalQuit.setup).toHaveBeenCalledWith(@s, @options)

      it 'calls teardown on final', ->
        spyOn(@finalQuit, 'teardown')

        @s.start()
        @s.next()
        @s.stop(true)
        @s.stop(true)

        expect(@finalQuit.teardown).toHaveBeenCalledWith(@s, @options)

    describe 'interaction with view buttons', ->

      it 'handles next button', ->
        @s.start()
        @s.view.onClickNext({})
        expect(@s.model.get('current_step').index).toEqual(1)

      it 'handles close button', ->
        @s.start()
        @s.view.onClickClose({})
        expect(@s.model.get('current_step').final).toEqual(true)

        @s.view.onClickClose({})
        expect(@s.model.get('current_step')).toEqual(null)

    describe 'events', ->
      it 'emits a start event', ->
        spy = jasmine.createSpy()
        @s.bind('start', spy)
        @s.start()
        expect(spy).toHaveBeenCalled()

      it 'emits a stop event', ->
        spy = jasmine.createSpy()
        @s.bind('stop', spy)
        @s.start()
        @s.next()
        @s.stop(false)
        expect(spy).toHaveBeenCalled()

BasicTourTests 'with Tourist.Tip.Simple', ->
  new Tourist.Tour
    stepOptions: @options
    steps: @steps
    cancelStep: @finalQuit
    successStep: @finalSucceed
    tipClass: 'Simple'

class HelloWorld
  @test: 'test'
console.log('hi')
class HelloWorld
  @test: 'test'
console.log('hi')
class HelloWorld
  @test: 'test'
console.log('hi')
system = require 'system'
if system.args.length is 1
  console.log 'Try to pass some args when invoking this script!'
else
  for arg, i in system.args
    console.log i + ': ' + arg
phantom.exit()

{spawn, execFile} = require "child_process"

child = spawn "ls", ["-lF", "/rooot"]

child.stdout.on "data", (data) ->
  console.log "spawnSTDOUT:", JSON.stringify data

child.stderr.on "data", (data) ->
  console.log "spawnSTDERR:", JSON.stringify data

child.on "exit", (code) ->
  console.log "spawnEXIT:", code

#child.kill "SIGKILL"

execFile "ls", ["-lF", "/usr"], null, (err, stdout, stderr) ->
  console.log "execFileSTDOUT:", JSON.stringify stdout
  console.log "execFileSTDERR:", JSON.stringify stderr

setTimeout (-> phantom.exit 0), 2000

page = require('webpage').create()

page.viewportSize = { width: 400, height : 400 }
page.content = '<html><body><canvas id="surface"></canvas></body></html>'

page.evaluate ->
  el = document.getElementById 'surface'
  context = el.getContext '2d'
  width = window.innerWidth
  height = window.innerHeight
  cx = width / 2
  cy = height / 2
  radius = width / 2.3
  i = 0

  el.width = width
  el.height = height
  imageData = context.createImageData(width, height)
  pixels = imageData.data

  for y in [0...height]
    for x in [0...width]
      i = i + 4
      rx = x - cx
      ry = y - cy
      d = rx * rx + ry * ry
      if d < radius * radius
        hue = 6 * (Math.atan2(ry, rx) + Math.PI) / (2 * Math.PI)
        sat = Math.sqrt(d) / radius
        g = Math.floor(hue)
        f = hue - g
        u = 255 * (1 - sat)
        v = 255 * (1 - sat * f)
        w = 255 * (1 - sat * (1 - f))
        pixels[i] = [255, v, u, u, w, 255, 255][g]
        pixels[i + 1] = [w, 255, 255, v, u, u, w][g]
        pixels[i + 2] = [u, u, w, 255, 255, v, u][g]
        pixels[i + 3] = 255

  context.putImageData imageData, 0, 0
  document.body.style.backgroundColor = 'white'
  document.body.style.margin = '0px'

page.render('colorwheel.png')

phantom.exit()

t = 10
interval = setInterval ->
  if t > 0
    console.log t--
  else
    console.log 'BLAST OFF!'
    phantom.exit()
, 1000

page = require('webpage').create()
system = require 'system'

page.onInitialized = ->
  page.evaluate ->
    userAgent = window.navigator.userAgent
    platform = window.navigator.platform
    window.navigator =
      appCodeName: 'Mozilla'
      appName: 'Netscape'
      cookieEnabled: false
      sniffed: false

    window.navigator.__defineGetter__ 'userAgent', ->
      window.navigator.sniffed = true
      userAgent

    window.navigator.__defineGetter__ 'platform', ->
      window.navigator.sniffed = true
      platform

if system.args.length is 1
  console.log 'Usage: detectsniff.coffee <some URL>'
  phantom.exit 1
else
  address = system.args[1]
  console.log 'Checking ' + address + '...'
  page.open address, (status) ->
    if status isnt 'success'
      console.log 'FAIL to load the address'
      phantom.exit()
    else
      window.setTimeout ->
        sniffed = page.evaluate(->
          navigator.sniffed
        )
        if sniffed
          console.log 'The page tried to sniff the user agent.'
        else
          console.log 'The page did not try to sniff the user agent.'
        phantom.exit()
      , 1500

# Get driving direction using Google Directions API.

page = require('webpage').create()
system = require 'system'

if system.args.length < 3
  console.log 'Usage: direction.coffee origin destination'
  console.log 'Example: direction.coffee "San Diego" "Palo Alto"'
  phantom.exit 1
else
  origin = system.args[1]
  dest = system.args[2]
  page.open encodeURI('http://maps.googleapis.com/maps/api/directions/xml?origin=' + origin +
                      '&destination=' + dest + '&units=imperial&mode=driving&sensor=false'),
            (status) ->
              if status isnt 'success'
                console.log 'Unable to access network'
              else
                steps = page.content.match(/<html_instructions>(.*)<\/html_instructions>/ig)
                if not steps
                  console.log 'No data available for ' + origin + ' to ' + dest
                else
                  for ins in steps
                    ins = ins.replace(/\&lt;/ig, '<').replace(/\&gt;/ig, '>')
                    ins = ins.replace(/\<div/ig, '\n<div')
                    ins = ins.replace(/<.*?>/g, '')
                    console.log(ins)
                  console.log ''
                  console.log page.content.match(/<copyrights>.*<\/copyrights>/ig).join('').replace(/<.*?>/g, '')
              phantom.exit()

# echoToFile.coffee - Write in a given file all the parameters passed on the CLI
fs = require 'fs'
system = require 'system'

if system.args.length < 3
  console.log "Usage: echoToFile.coffee DESTINATION_FILE <arguments to echo...>"
  phantom.exit 1
else
  content = ""
  f = null
  i = 2
  while i < system.args.length
    content += system.args[i] + (if i == system.args.length - 1 then "" else " ")
    ++i
  try
    fs.write system.args[1], content, "w"
  catch e
    console.log e
  phantom.exit()

feature = undefined
supported = []
unsupported = []
phantom.injectJs "modernizr.js"
console.log "Detected features (using Modernizr " + Modernizr._version + "):"
for feature of Modernizr
  if Modernizr.hasOwnProperty(feature)
    if feature[0] isnt "_" and typeof Modernizr[feature] isnt "function" and feature isnt "input" and feature isnt "inputtypes"
      if Modernizr[feature]
        supported.push feature
      else
        unsupported.push feature
console.log ""
console.log "Supported:"
supported.forEach (e) ->
  console.log "  " + e

console.log ""
console.log "Not supported:"
unsupported.forEach (e) ->
  console.log "  " + e

phantom.exit()
fibs = [0, 1]
f = ->
  console.log fibs[fibs.length - 1]
  fibs.push fibs[fibs.length - 1] + fibs[fibs.length - 2]
  if fibs.length > 10
    window.clearInterval ticker
    phantom.exit()
ticker = window.setInterval(f, 300)

# List following and followers from several accounts

users = [
  'PhantomJS'
  'ariyahidayat'
  'detronizator'
  'KDABQt'
  'lfranchi'
  'jonleighton'
  '_jamesmgreene'
  'Vitalliumm'
  ]

follow = (user, callback) ->
  page = require('webpage').create()
  page.open 'http://mobile.twitter.com/' + user, (status) ->
    if status is 'fail'
      console.log user + ': ?'
    else
      data = page.evaluate -> document.querySelector('div.profile td.stat.stat-last div.statnum').innerText;
      console.log user + ': ' + data
    page.close()
    callback.apply()

process = () ->
  if (users.length > 0)
    user = users[0]
    users.splice(0, 1)
    follow(user, process)
  else
    phantom.exit()

process()

console.log 'Hello, world!'
phantom.exit()

# Upload an image to imagebin.org

page = require('webpage').create()
system = require 'system'

if system.args.length isnt 2
  console.log 'Usage: imagebin.coffee filename'
  phantom.exit 1
else
  fname = system.args[1]
  page.open 'http://imagebin.org/index.php?page=add', ->
    page.uploadFile 'input[name=image]', fname
    page.evaluate ->
      document.querySelector('input[name=nickname]').value = 'phantom'
      document.querySelector('input[name=disclaimer_agree]').click()
      document.querySelector('form').submit()

    window.setTimeout ->
      phantom.exit()
    , 3000

# Use 'page.injectJs()' to load the script itself in the Page context

if phantom?
  page = require('webpage').create()

  # Route "console.log()" calls from within the Page context to the main
  # Phantom context (i.e. current "this")
  page.onConsoleMessage = (msg) -> console.log(msg)

  page.onAlert = (msg) -> console.log(msg)

  console.log "* Script running in the Phantom context."
  console.log "* Script will 'inject' itself in a page..."
  page.open "about:blank", (status) ->
    if status is "success"
      if page.injectJs("injectme.coffee")
        console.log "... done injecting itself!"
      else
        console.log "... fail! Check the $PWD?!"
    phantom.exit()
else
  alert "* Script running in the Page context."


# Give the estimated location based on the IP address.

window.cb = (data) ->
  loc = data.city
  if data.region_name.length > 0
    loc = loc + ', ' + data.region_name
  console.log 'IP address: ' + data.ip
  console.log 'Estimated location: ' + loc
  phantom.exit()

el = document.createElement 'script'
el.src = 'http://freegeoip.net/json/?callback=window.cb'
document.body.appendChild el

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: loadspeed.coffee <some URL>'
  phantom.exit 1
else
  t = Date.now()
  address = system.args[1]
  page.open address, (status) ->
    if status isnt 'success'
      console.log('FAIL to load the address')
    else
      t = Date.now() - t
      console.log('Page title is ' + page.evaluate( (-> document.title) ))
      console.log('Loading time ' + t + ' msec')
    phantom.exit()


page = require("webpage").create()
system = require("system")

if system.args.length < 2
  console.log "Usage: loadurlwithoutcss.js URL"
  phantom.exit()

address = system.args[1]

page.onResourceRequested = (requestData, request) ->
  if (/http:\/\/.+?\.css/g).test(requestData["url"]) or requestData["Content-Type"] is "text/css"
    console.log "The url of the request is matching. Aborting: " + requestData["url"]
    request.abort()

page.open address, (status) ->
  if status is "success"
    phantom.exit()
  else
    console.log "Unable to load the address!"
    phantom.exit()

universe = require './universe'
universe.start()
console.log 'The answer is' + universe.answer
phantom.exit()

# List movies from kids-in-mind.com

window.cbfunc = (data) ->
  globaldata = data
  list = data.query.results.movie
  for item in list
    console.log item.title + ' [' + item.rating.MPAA.content + ']'
  phantom.exit()

el = document.createElement 'script'
el.src =
"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20movies.kids-in-mind&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=window.cbfunc"
document.body.appendChild el

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: netlog.coffee <some URL>'
  phantom.exit 1
else
  address = system.args[1]
  page.onResourceRequested = (req) ->
    console.log 'requested ' + JSON.stringify(req, undefined, 4)

  page.onResourceReceived = (res) ->
    console.log 'received ' + JSON.stringify(res, undefined, 4)

  page.open address, (status) ->
    if status isnt 'success'
      console.log 'FAIL to load the address'
    phantom.exit()

if not Date::toISOString
  Date::toISOString = ->
    pad = (n) ->
      if n < 10 then '0' + n else n
    ms = (n) ->
      if n < 10 then '00' + n else (if n < 100 then '0' + n else n)
    @getFullYear() + '-' +
    pad(@getMonth() + 1) + '-' +
    pad(@getDate()) + 'T' +
    pad(@getHours()) + ':' +
    pad(@getMinutes()) + ':' +
    pad(@getSeconds()) + '.' +
    ms(@getMilliseconds()) + 'Z'

createHAR = (address, title, startTime, resources) ->
  entries = []

  resources.forEach (resource) ->
    request = resource.request
    startReply = resource.startReply
    endReply = resource.endReply

    if not request or not startReply or not endReply
      return

    entries.push
      startedDateTime: request.time.toISOString()
      time: endReply.time - request.time
      request:
        method: request.method
        url: request.url
        httpVersion: 'HTTP/1.1'
        cookies: []
        headers: request.headers
        queryString: []
        headersSize: -1
        bodySize: -1

      response:
        status: endReply.status
        statusText: endReply.statusText
        httpVersion: 'HTTP/1.1'
        cookies: []
        headers: endReply.headers
        redirectURL: ''
        headersSize: -1
        bodySize: startReply.bodySize
        content:
          size: startReply.bodySize
          mimeType: endReply.contentType

      cache: {}
      timings:
        blocked: 0
        dns: -1
        connect: -1
        send: 0
        wait: startReply.time - request.time
        receive: endReply.time - startReply.time
        ssl: -1
      pageref: address

  log:
    version: '1.2'
    creator:
      name: 'PhantomJS'
      version: phantom.version.major + '.' + phantom.version.minor + '.' + phantom.version.patch

    pages: [
      startedDateTime: startTime.toISOString()
      id: address
      title: title
      pageTimings:
        onLoad: page.endTime - page.startTime
    ]
    entries: entries

page = require('webpage').create()
system = require 'system'

if system.args.length is 1
  console.log 'Usage: netsniff.coffee <some URL>'
  phantom.exit 1
else
  page.address = system.args[1]
  page.resources = []

  page.onLoadStarted = ->
    page.startTime = new Date()

  page.onResourceRequested = (req) ->
    page.resources[req.id] =
      request: req
      startReply: null
      endReply: null

  page.onResourceReceived = (res) ->
    if res.stage is 'start'
      page.resources[res.id].startReply = res
    if res.stage is 'end'
      page.resources[res.id].endReply = res

  page.open page.address, (status) ->
    if status isnt 'success'
      console.log 'FAIL to load the address'
      phantom.exit(1)
    else
      page.endTime = new Date()
      page.title = page.evaluate ->
        document.title

      har = createHAR page.address, page.title, page.startTime, page.resources
      console.log JSON.stringify har, undefined, 4
      phantom.exit()

helloWorld = () -> console.log phantom.outputEncoding + ": こんにちは、世界！"

console.log "Using default encoding..."
helloWorld()

console.log "\nUsing other encodings..."
for enc in ["euc-jp", "sjis", "utf8", "System"]
  do (enc) ->
    phantom.outputEncoding = enc
    helloWorld()

phantom.exit()

# The purpose of this is to show how and when events fire, considering 5 steps
# happening as follows:
#
#      1. Load URL
#      2. Load same URL, but adding an internal FRAGMENT to it
#      3. Click on an internal Link, that points to another internal FRAGMENT
#      4. Click on an external Link, that will send the page somewhere else
#      5. Close page
#
# Take particular care when going through the output, to understand when
# things happen (and in which order). Particularly, notice what DOESN'T
# happen during step 3.
#
# If invoked with "-v" it will print out the Page Resources as they are
# Requested and Received.
#
# NOTE.1: The "onConsoleMessage/onAlert/onPrompt/onConfirm" events are
# registered but not used here. This is left for you to have fun with.
# NOTE.2: This script is not here to teach you ANY JavaScript. It's aweful!
# NOTE.3: Main audience for this are people new to PhantomJS.
printArgs = ->
  i = undefined
  ilen = undefined
  i = 0
  ilen = arguments_.length

  while i < ilen
    console.log "    arguments[" + i + "] = " + JSON.stringify(arguments_[i])
    ++i
  console.log ""
sys = require("system")
page = require("webpage").create()
logResources = false
step1url = "http://en.wikipedia.org/wiki/DOM_events"
step2url = "http://en.wikipedia.org/wiki/DOM_events#Event_flow"
logResources = true  if sys.args.length > 1 and sys.args[1] is "-v"

#//////////////////////////////////////////////////////////////////////////////
page.onInitialized = ->
  console.log "page.onInitialized"
  printArgs.apply this, arguments_

page.onLoadStarted = ->
  console.log "page.onLoadStarted"
  printArgs.apply this, arguments_

page.onLoadFinished = ->
  console.log "page.onLoadFinished"
  printArgs.apply this, arguments_

page.onUrlChanged = ->
  console.log "page.onUrlChanged"
  printArgs.apply this, arguments_

page.onNavigationRequested = ->
  console.log "page.onNavigationRequested"
  printArgs.apply this, arguments_

if logResources is true
  page.onResourceRequested = ->
    console.log "page.onResourceRequested"
    printArgs.apply this, arguments_

  page.onResourceReceived = ->
    console.log "page.onResourceReceived"
    printArgs.apply this, arguments_
page.onClosing = ->
  console.log "page.onClosing"
  printArgs.apply this, arguments_


# window.console.log(msg);
page.onConsoleMessage = ->
  console.log "page.onConsoleMessage"
  printArgs.apply this, arguments_


# window.alert(msg);
page.onAlert = ->
  console.log "page.onAlert"
  printArgs.apply this, arguments_


# var confirmed = window.confirm(msg);
page.onConfirm = ->
  console.log "page.onConfirm"
  printArgs.apply this, arguments_


# var user_value = window.prompt(msg, default_value);
page.onPrompt = ->
  console.log "page.onPrompt"
  printArgs.apply this, arguments_


#//////////////////////////////////////////////////////////////////////////////
setTimeout (->
  console.log ""
  console.log "### STEP 1: Load '" + step1url + "'"
  page.open step1url
), 0
setTimeout (->
  console.log ""
  console.log "### STEP 2: Load '" + step2url + "' (load same URL plus FRAGMENT)"
  page.open step2url
), 5000
setTimeout (->
  console.log ""
  console.log "### STEP 3: Click on page internal link (aka FRAGMENT)"
  page.evaluate ->
    ev = document.createEvent("MouseEvents")
    ev.initEvent "click", true, true
    document.querySelector("a[href='#Event_object']").dispatchEvent ev

), 10000
setTimeout (->
  console.log ""
  console.log "### STEP 4: Click on page external link"
  page.evaluate ->
    ev = document.createEvent("MouseEvents")
    ev.initEvent "click", true, true
    document.querySelector("a[title='JavaScript']").dispatchEvent ev

), 15000
setTimeout (->
  console.log ""
  console.log "### STEP 5: Close page and shutdown (with a delay)"
  page.close()
  setTimeout (->
    phantom.exit()
  ), 100
), 20000
p = require("webpage").create()

p.onConsoleMessage = (msg) ->
  console.log msg

# Calls to "callPhantom" within the page 'p' arrive here
p.onCallback = (msg) ->
  console.log "Received by the 'phantom' main context: " + msg
  "Hello there, I'm coming to you from the 'phantom' context instead"

p.evaluate ->
  # Return-value of the "onCallback" handler arrive here
  callbackResponse = window.callPhantom "Hello, I'm coming to you from the 'page' context"
  console.log "Received by the 'page' context: " + callbackResponse

phantom.exit()

# Read the Phantom webpage '#intro' element text using jQuery and "includeJs"

page = require('webpage').create()

page.onConsoleMessage = (msg) -> console.log msg

page.open "http://www.phantomjs.org", (status) ->
  if status is "success"
    page.includeJs "http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js", ->
      page.evaluate ->
        console.log "$(\"#intro\").text() -> " + $("#intro").text()
      phantom.exit()


# Find pizza in Mountain View using Yelp

page = require('webpage').create()
url = 'http://lite.yelp.com/search?find_desc=pizza&find_loc=94040&find_submit=Search'

page.open url,
  (status) ->
    if status isnt 'success'
      console.log 'Unable to access network'
    else
      results = page.evaluate ->
        pizza = []
        list = document.querySelectorAll 'address'
        for item in list
          pizza.push(item.innerText)
        return pizza
      console.log results.join('\n')
    phantom.exit()

# Example using HTTP POST operation

page = require('webpage').create()
server = 'http://posttestserver.com/post.php?dump'
data = 'universe=expanding&answer=42'

page.open server, 'post', data, (status) ->
  if status isnt 'success'
    console.log 'Unable to post!'
  else
    console.log page.content
  phantom.exit()

# Example using HTTP POST operation
page = require("webpage").create()
server = require("webserver").create()
system = require("system")
data = "universe=expanding&answer=42"
if system.args.length isnt 2
  console.log "Usage: postserver.js <portnumber>"
  phantom.exit 1
port = system.args[1]
service = server.listen(port, (request, response) ->
  console.log "Request received at " + new Date()
  response.statusCode = 200
  response.headers =
    Cache: "no-cache"
    "Content-Type": "text/plain;charset=utf-8"

  response.write JSON.stringify(request, null, 4)
  response.close()
)
page.open "http://localhost:" + port + "/", "post", data, (status) ->
  if status isnt "success"
    console.log "Unable to post!"
  else
    console.log page.plainText
  phantom.exit()

system = require("system")
env = system.env
key = undefined
for key of env
  console.log key + "=" + env[key]  if env.hasOwnProperty(key)
phantom.exit()
someCallback = (pageNum, numPages) ->
  "<h1> someCallback: " + pageNum + " / " + numPages + "</h1>"
page = require("webpage").create()
system = require("system")
if system.args.length < 3
  console.log "Usage: printheaderfooter.js URL filename"
  phantom.exit 1
else
  address = system.args[1]
  output = system.args[2]
  page.viewportSize =
    width: 600
    height: 600

  page.paperSize =
    format: "A4"
    margin: "1cm"
    
    # default header/footer for pages that don't have custom overwrites (see below) 
    header:
      height: "1cm"
      contents: phantom.callback((pageNum, numPages) ->
        return ""  if pageNum is 1
        "<h1>Header <span style='float:right'>" + pageNum + " / " + numPages + "</span></h1>"
      )

    footer:
      height: "1cm"
      contents: phantom.callback((pageNum, numPages) ->
        return ""  if pageNum is numPages
        "<h1>Footer <span style='float:right'>" + pageNum + " / " + numPages + "</span></h1>"
      )

  page.open address, (status) ->
    if status isnt "success"
      console.log "Unable to load the address!"
    else
      
      # check whether the loaded page overwrites the header/footer setting,
      #               i.e. whether a PhantomJSPriting object exists. Use that then instead
      #               of our defaults above.
      #
      #               example:
      #               <html>
      #                 <head>
      #                   <script type="text/javascript">
      #                     var PhantomJSPrinting = {
      #                        header: {
      #                            height: "1cm",
      #                            contents: function(pageNum, numPages) { return pageNum + "/" + numPages; }
      #                        },
      #                        footer: {
      #                            height: "1cm",
      #                            contents: function(pageNum, numPages) { return pageNum + "/" + numPages; }
      #                        }
      #                     };
      #                   </script>
      #                 </head>
      #                 <body><h1>asdfadsf</h1><p>asdfadsfycvx</p></body>
      #              </html>
      #            
      if page.evaluate(->
        typeof PhantomJSPrinting is "object"
      )
        paperSize = page.paperSize
        paperSize.header.height = page.evaluate(->
          PhantomJSPrinting.header.height
        )
        paperSize.header.contents = phantom.callback((pageNum, numPages) ->
          page.evaluate ((pageNum, numPages) ->
            PhantomJSPrinting.header.contents pageNum, numPages
          ), pageNum, numPages
        )
        paperSize.footer.height = page.evaluate(->
          PhantomJSPrinting.footer.height
        )
        paperSize.footer.contents = phantom.callback((pageNum, numPages) ->
          page.evaluate ((pageNum, numPages) ->
            PhantomJSPrinting.footer.contents pageNum, numPages
          ), pageNum, numPages
        )
        page.paperSize = paperSize
        console.log page.paperSize.header.height
        console.log page.paperSize.footer.height
      window.setTimeout (->
        page.render output
        phantom.exit()
      ), 200

page = require("webpage").create()
system = require("system")
if system.args.length < 7
  console.log "Usage: printmargins.js URL filename LEFT TOP RIGHT BOTTOM"
  console.log "  margin examples: \"1cm\", \"10px\", \"7mm\", \"5in\""
  phantom.exit 1
else
  address = system.args[1]
  output = system.args[2]
  marginLeft = system.args[3]
  marginTop = system.args[4]
  marginRight = system.args[5]
  marginBottom = system.args[6]
  page.viewportSize =
    width: 600
    height: 600

  page.paperSize =
    format: "A4"
    margin:
      left: marginLeft
      top: marginTop
      right: marginRight
      bottom: marginBottom

  page.open address, (status) ->
    if status isnt "success"
      console.log "Unable to load the address!"
    else
      window.setTimeout (->
        page.render output
        phantom.exit()
      ), 200

page = require('webpage').create()
system = require 'system'

if system.args.length < 3 or system.args.length > 4
  console.log 'Usage: rasterize.coffee URL filename [paperwidth*paperheight|paperformat]'
  console.log '  paper (pdf output) examples: "5in*7.5in", "10cm*20cm", "A4", "Letter"'
  phantom.exit 1
else
  address = system.args[1]
  output = system.args[2]
  page.viewportSize = { width: 600, height: 600 }
  if system.args.length is 4 and system.args[2].substr(-4) is ".pdf"
    size = system.args[3].split '*'
    if size.length is 2
      page.paperSize = { width: size[0], height: size[1], border: '0px' }
    else
      page.paperSize = { format: system.args[3], orientation: 'portrait', border: '1cm' }
  page.open address, (status) ->
    if status isnt 'success'
      console.log 'Unable to load the address!'
      phantom.exit()
    else
      window.setTimeout (-> page.render output; phantom.exit()), 200

# Render Multiple URLs to file

system = require("system")

# Render given urls
# @param array of URLs to render
# @param callbackPerUrl Function called after finishing each URL, including the last URL
# @param callbackFinal Function called after finishing everything
RenderUrlsToFile = (urls, callbackPerUrl, callbackFinal) ->
  urlIndex = 0 # only for easy file naming
  webpage = require("webpage")
  page = null
  getFilename = ->
    "rendermulti-" + urlIndex + ".png"

  next = (status, url, file) ->
    page.close()
    callbackPerUrl status, url, file
    retrieve()

  retrieve = ->
    if urls.length > 0
      url = urls.shift()
      urlIndex++
      page = webpage.create()
      page.viewportSize =
        width: 800
        height: 600

      page.settings.userAgent = "Phantom.js bot"
      page.open "http://" + url, (status) ->
        file = getFilename()
        if status is "success"
          window.setTimeout (->
            page.render file
            next status, url, file
          ), 200
        else
          next status, url, file

    else
      callbackFinal()

  retrieve()
arrayOfUrls = null
if system.args.length > 1
  arrayOfUrls = Array::slice.call(system.args, 1)
else
  # Default (no args passed)
  console.log "Usage: phantomjs render_multi_url.js [domain.name1, domain.name2, ...]"
  arrayOfUrls = ["www.google.com", "www.bbc.co.uk", "www.phantomjs.org"]

RenderUrlsToFile arrayOfUrls, ((status, url, file) ->
  if status isnt "success"
    console.log "Unable to render '" + url + "'"
  else
    console.log "Rendered '" + url + "' at '" + file + "'"
), ->
  phantom.exit()


system = require 'system'

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
  start = new Date().getTime()
  condition = false
  f = ->
    if (new Date().getTime() - start < timeOutMillis) and not condition
      # If not time-out yet and condition not yet fulfilled
      condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
    else
      if not condition
        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else
        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in #{new Date().getTime() - start}ms."
        if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
  interval = setInterval f, 100 #< repeat check every 100ms

if system.args.length isnt 2
  console.log 'Usage: run-jasmine.coffee URL'
  phantom.exit 1

page = require('webpage').create()

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg

page.open system.args[1], (status) ->
  if status isnt 'success'
    console.log 'Unable to access network'
    phantom.exit()
  else
    waitFor ->
      page.evaluate ->
        if document.body.querySelector '.finished-at'
          return true
        return false
    , ->
      page.evaluate ->
        console.log document.body.querySelector('.description').innerText
        list = document.body.querySelectorAll('.failed > .description, .failed > .messages > .resultMessage')
        for el in list
          console.log el.innerText

      phantom.exit()

system = require 'system'

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
  start = new Date().getTime()
  condition = false
  f = ->
    if (new Date().getTime() - start < timeOutMillis) and not condition
      # If not time-out yet and condition not yet fulfilled
      condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
    else
      if not condition
        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else
        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in #{new Date().getTime() - start}ms."
        if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
  interval = setInterval f, 100 #< repeat check every 100ms

if system.args.length isnt 2
  console.log 'Usage: run-qunit.coffee URL'
  phantom.exit 1

page = require('webpage').create()

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg

page.open system.args[1], (status) ->
  if status isnt 'success'
    console.log 'Unable to access network'
    phantom.exit 1
  else
    waitFor ->
      page.evaluate ->
        el = document.getElementById 'qunit-testresult'
        if el and el.innerText.match 'completed'
          return true
        return false
    , ->
      failedNum = page.evaluate ->
        el = document.getElementById 'qunit-testresult'
        console.log el.innerText
        try
          return el.getElementsByClassName('failed')[0].innerHTML
        catch e
        return 10000

      phantom.exit if parseInt(failedNum, 10) > 0 then 1 else 0

# List all the files in a Tree of Directories
system = require 'system'

if system.args.length != 2
  console.log "Usage: phantomjs scandir.coffee DIRECTORY_TO_SCAN"
  phantom.exit 1
scanDirectory = (path) ->
  fs = require 'fs'
  if fs.exists(path) and fs.isFile(path)
    console.log path
  else if fs.isDirectory(path)
    fs.list(path).forEach (e) ->
      scanDirectory path + "/" + e  if e != "." and e != ".."

scanDirectory system.args[1]
phantom.exit()

# Show BBC seasonal food list.

window.cbfunc = (data) ->
  list = data.query.results.results.result
  names = ['January', 'February', 'March',
           'April', 'May', 'June',
           'July', 'August', 'September',
           'October', 'November', 'December']
  for item in list
    console.log [item.name.replace(/\s/ig, ' '), ':',
                names[item.atItsBestUntil], 'to',
                names[item.atItsBestFrom]].join(' ')
  phantom.exit()

el = document.createElement 'script'
el.src = 'http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20bbc.goodfood.seasonal%3B&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=window.cbfunc'
document.body.appendChild el

page = require("webpage").create()
server = require("webserver").create()
system = require("system")
host = undefined
port = undefined
if system.args.length isnt 2
  console.log "Usage: server.js <some port>"
  phantom.exit 1
else
  port = system.args[1]
  listening = server.listen(port, (request, response) ->
    console.log "GOT HTTP REQUEST"
    console.log JSON.stringify(request, null, 4)
    
    # we set the headers here
    response.statusCode = 200
    response.headers =
      Cache: "no-cache"
      "Content-Type": "text/html"

    
    # this is also possible:
    response.setHeader "foo", "bar"
    
    # now we write the body
    # note: the headers above will now be sent implictly
    response.write "<html><head><title>YES!</title></head>"
    
    # note: writeBody can be called multiple times
    response.write "<body><p>pretty cool :)</body></html>"
    response.close()
  )
  unless listening
    console.log "could not create web server listening on port " + port
    phantom.exit()
  url = "http://localhost:" + port + "/foo/bar.php?asdf=true"
  console.log "SENDING REQUEST TO:"
  console.log url
  page.open url, (status) ->
    if status isnt "success"
      console.log "FAIL to load the address"
    else
      console.log "GOT REPLY FROM SERVER:"
      console.log page.content
    phantom.exit()

port = undefined
server = undefined
service = undefined
system = require("system")
if system.args.length isnt 2
  console.log "Usage: serverkeepalive.js <portnumber>"
  phantom.exit 1
else
  port = system.args[1]
  server = require("webserver").create()
  service = server.listen(port,
    keepAlive: true
  , (request, response) ->
    console.log "Request at " + new Date()
    console.log JSON.stringify(request, null, 4)
    body = JSON.stringify(request, null, 4)
    response.statusCode = 200
    response.headers =
      Cache: "no-cache"
      "Content-Type": "text/plain"
      Connection: "Keep-Alive"
      "Keep-Alive": "timeout=5, max=100"
      "Content-Length": body.length

    response.write body
    response.close()
  )
  if service
    console.log "Web server running on port " + port
  else
    console.log "Error: Could not create web server listening on port " + port
    phantom.exit()
system = require 'system'

if system.args.length is 1
  console.log "Usage: simpleserver.coffee <portnumber>"
  phantom.exit 1
else
  port = system.args[1]
  server = require("webserver").create()

  service = server.listen(port, (request, response) ->

    console.log "Request at " + new Date()
    console.log JSON.stringify(request, null, 4)

    response.statusCode = 200
    response.headers =
      Cache: "no-cache"
      "Content-Type": "text/html"

    response.write "<html>"
    response.write "<head>"
    response.write "<title>Hello, world!</title>"
    response.write "</head>"
    response.write "<body>"
    response.write "<p>This is from PhantomJS web server.</p>"
    response.write "<p>Request data:</p>"
    response.write "<pre>"
    response.write JSON.stringify(request, null, 4)
    response.write "</pre>"
    response.write "</body>"
    response.write "</html>"
    response.close()
  )
  if service
    console.log "Web server running on port " + port
  else
    console.log "Error: Could not create web server listening on port " + port
    phantom.exit()

###
Sort integers from the command line in a very ridiculous way: leveraging timeouts :P
###

system = require 'system'

if system.args.length < 2
  console.log "Usage: phantomjs sleepsort.coffee PUT YOUR INTEGERS HERE SEPARATED BY SPACES"
  phantom.exit 1
else
  sortedCount = 0
  args = Array.prototype.slice.call(system.args, 1)
  for int in args
    setTimeout (do (int) ->
      ->
        console.log int
        ++sortedCount
        phantom.exit() if sortedCount is args.length),
      int


system = require 'system'

system.stdout.write 'Hello, system.stdout.write!'
system.stdout.writeLine '\nHello, system.stdout.writeLine!'

system.stderr.write 'Hello, system.stderr.write!'
system.stderr.writeLine '\nHello, system.stderr.writeLine!'

system.stdout.writeLine 'system.stdin.readLine(): '
line = system.stdin.readLine()
system.stdout.writeLine JSON.stringify line

# This is essentially a `readAll`
system.stdout.writeLine 'system.stdin.read(5): (ctrl+D to end)'
input = system.stdin.read 5
system.stdout.writeLine JSON.stringify input

phantom.exit 0

page = require('webpage').create()

page.viewportSize = { width: 320, height: 480 }

page.open 'http://news.google.com/news/i/section?&topic=t',
  (status) ->
    if status isnt 'success'
      console.log 'Unable to access the network!'
    else
      page.evaluate ->
        body = document.body
        body.style.backgroundColor = '#fff'
        body.querySelector('div#title-block').style.display = 'none'
        body.querySelector('form#edition-picker-form')
          .parentElement.parentElement.style.display = 'none'
      page.render 'technews.png'
    phantom.exit()

# Get twitter status for given account (or for the default one, "PhantomJS")

page = require('webpage').create()
system = require 'system'
twitterId = 'PhantomJS' #< default value

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg

# Print usage message, if no twitter ID is passed
if system.args.length < 2
  console.log 'Usage: tweets.coffee [twitter ID]'
else
  twitterId = system.args[1]

# Heading
console.log "*** Latest tweets from @#{twitterId} ***\n"

# Open Twitter Mobile and, onPageLoad, do...
page.open encodeURI("http://mobile.twitter.com/#{twitterId}"), (status) ->
  # Check for page load success
  if status isnt 'success'
    console.log 'Unable to access network'
  else
    # Execute some DOM inspection within the page context
    page.evaluate ->
      list = document.querySelectorAll 'div.tweet-text'
      for i, j in list
        console.log "#{j + 1}: #{i.innerText}"
  phantom.exit()

# Modify global object at the page initialization.
# In this example, effectively Math.random() always returns 0.42.

page = require('webpage').create()
page.onInitialized = ->
  page.evaluate ->
    Math.random = ->
      42 / 100

page.open "http://ariya.github.com/js/random/", (status) ->
  if status != "success"
    console.log "Network error."
  else
    console.log page.evaluate(->
      document.getElementById("numbers").textContent
    )
  phantom.exit()


page = require('webpage').create()

console.log 'The default user agent is ' + page.settings.userAgent

page.settings.userAgent = 'SpecialAgent'
page.open 'http://www.httpuseragent.org', (status) ->
  if status isnt 'success'
    console.log 'Unable to access network'
  else
    console.log page.evaluate -> document.getElementById('myagent').innerText
  phantom.exit()

console.log 'using PhantomJS version ' +
            phantom.version.major + '.' +
            phantom.version.minor + '.' +
            phantom.version.patch
phantom.exit()

##
# Wait until the test condition is true or a timeout occurs. Useful for waiting
# on a server response or for a ui change (fadeIn, etc.) to occur.
#
# @param testFx javascript condition that evaluates to a boolean,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param onReady what to do when testFx condition is fulfilled,
# it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
# as a callback function.
# @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
##
waitFor = (testFx, onReady, timeOutMillis=3000) ->
  start = new Date().getTime()
  condition = false
  f = ->
    if (new Date().getTime() - start < timeOutMillis) and not condition
      # If not time-out yet and condition not yet fulfilled
      condition = (if typeof testFx is 'string' then eval testFx else testFx()) #< defensive code
    else
      if not condition
        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else
        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in #{new Date().getTime() - start}ms."
        if typeof onReady is 'string' then eval onReady else onReady() #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
  interval = setInterval f, 250 #< repeat check every 250ms


page = require('webpage').create()

# Open Twitter on 'sencha' profile and, onPageLoad, do...
page.open 'http://twitter.com/#!/sencha', (status) ->
  # Check for page load success
  if status isnt 'success'
    console.log 'Unable to access network'
  else
    # Wait for 'signin-dropdown' to be visible
    waitFor ->
      # Check in the page if a specific element is now visible
      page.evaluate ->
        $('#signin-dropdown').is ':visible'
    , ->
       console.log 'The sign-in dialog should be visible now.'
       phantom.exit()

pageTitle = (page) ->
  page.evaluate ->
    window.document.title
setPageTitle = (page, newTitle) ->
  page.evaluate ((newTitle) ->
    window.document.title = newTitle
  ), newTitle
p = require("webpage").create()
p.open "../test/webpage-spec-frames/index.html", (status) ->
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(\"frame1\"): " + p.switchToChildFrame("frame1")
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(\"frame1-2\"): " + p.switchToChildFrame("frame1-2")
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToParentFrame(): " + p.switchToParentFrame()
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(0): " + p.switchToChildFrame(0)
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToMainFrame()"
  p.switchToMainFrame()
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  console.log "p.switchToChildFrame(\"frame2\"): " + p.switchToChildFrame("frame2")
  console.log "pageTitle(): " + pageTitle(p)
  console.log "currentFrameName(): " + p.currentFrameName()
  console.log "childFramesCount(): " + p.childFramesCount()
  console.log "childFramesName(): " + p.childFramesName()
  console.log "setPageTitle(CURRENT TITLE+'-visited')"
  setPageTitle p, pageTitle(p) + "-visited"
  console.log ""
  phantom.exit()

page = require('webpage').create()
system = require 'system'

city = 'Mountain View, California'; # default
if system.args.length > 1
    city = Array.prototype.slice.call(system.args, 1).join(' ')
url = encodeURI 'http://api.openweathermap.org/data/2.1/find/name?q=' + city

console.log 'Checking weather condition for', city, '...'

page.open url, (status) ->
    if status isnt 'success'
        console.log 'Error: Unable to access network!'
    else
        result = page.evaluate ->
            return document.body.innerText
        try
            data = JSON.parse result
            data = data.list[0]
            console.log ''
            console.log 'City:',  data.name
            console.log 'Condition:', data.weather.map (entry) ->
                return entry.main
            console.log 'Temperature:', Math.round(data.main.temp - 273.15), 'C'
            console.log 'Humidity:', Math.round(data.main.humidity), '%'
        catch e
           console.log 'Error:', e.toString()

    phantom.exit()




window.Tourist = window.Tourist or {}

###
A model for the Tour. We'll only use the 'current_step' property.
###
class Tourist.Model extends Backbone.Model
  _module: 'Tourist'
# Just the tip, just to see how it feels.
window.Tourist.Tip = window.Tourist.Tip or {}


###
The flyout showing the content of each step.

This is the base class containing most of the logic. Can extend for different
tooltip implementations.
###
class Tourist.Tip.Base
	_module: 'Tourist'
	_.extend @prototype, Backbone.Events

	visable: false

	# You can override any of thsee templates for your own stuff
	skipButtonTemplate: '<button class="btn btn-default btn-sm pull-right tour-next">Skip this step →</button>'
	nextButtonTemplate: '<button class="btn btn-primary btn-sm pull-right tour-next">Next step →</button>'
	finalButtonTemplate: '<button class="btn btn-primary btn-sm pull-right tour-next">Finish up</button>'

	closeButtonTemplate: '<a class="btn btn-close tour-close" href="#"><i class="<%= classes %>"></i></a>'
	okButtonTemplate: '<button class="btn btn-sm tour-close btn-primary">Okay</button>'
	coverTemplate: '<div class="<%= classes %>" tabindex="1"></div>'

	actionLabelTemplate: _.template '<h4 class="action-label"><%= label %></h4>'
	actionLabels: ['Do this:', 'Then this:', 'Next this:']

	highlightClass: 'tour-highlight'
	closeButtonClasses: 'icon icon-remove'
	touristCoverClasses: 'tourist-cover'

	addedHightlightClasses: undefined

	template: _.template '''
		<div>
			<div class="tour-container">
				<%= close_button %>
				<%= content %>
				<p class="tour-counter <%= counter_class %>"><%= counter%></p>
			</div>
			<div class="tour-buttons">
				<%= buttons %>
			</div>
		</div>
	'''

	# options -
	#   model - a Tourist.Model object
	constructor: (@options={}) ->
		@el = $('<div/>')

		@initialize(options)

		@cover = $.parseHTML(@coverTemplate)

		@_bindClickEvents()

		Tourist.Tip.Base._cacheTip(this)

	destroy: ->
		@el.remove()
		@cover.remove() if @cover? and @cover.remove?
		
		false

	# Render the current step as specified by the Tour Model
	#
	# step - step object
	#
	# Return this
	render: (step) ->
		@hide()

		if step
			@_setTarget(step.target or false, step)
			@_setZIndex('')
			@_renderContent(step, @_buildContentElement(step))
			@show() if step.target
			@_setZIndex(step.zIndex, step) if step.zIndex

			cover = @_buildCover(step)
			$('body').append(cover) if step.cover?

			@visible = true

		this

	# Show the tip
	show: ->
		@cover.show().addClass('visible') if @cover?
		# Override me

	# Hide the tip
	hide: ->
		@cover.hide().removeClass('visible') if @cover?
		@visable = false
		# Override me

	# Set the element which the tip will point to
	#
	# targetElement - a jquery element
	# step - step object
	setTarget: (targetElement, step) ->
		@_setTarget(targetElement, step)

	# Unhighlight and unset the current target
	cleanupCurrentTarget: ->
		if @target? and @target.removeClass?
			@target.removeClass(@highlightClass)

			if @addedHightlightClasses?
				@target.removeClass(@addedHightlightClasses) 
				@addedHightlightClasses = undefined

		if @cover? 
			$('.tourist-cover').remove()

		@target = null

	###
	Event Handlers
	###

	# User clicked close or ok button
	onClickClose: (event) =>
		@trigger('click:close', this, event)
		false

	# User clicked next or skip button
	onClickNext: (event) =>
		@trigger('click:next', this, event)
		false


	###
	Private
	###

	# Returns the jquery element that contains all the tip data.
	_getTipElement: ->
		# Override me

	# Place content into your tip's body. Called in render()
	#
	# step - the step object for the current step
	# contentElement - a jquery element containing all the tip's content
	#
	# Returns nothing
	_renderContent: (step, contentElement) ->
		# Override me

	# Bind to the buttons
	_bindClickEvents: ->
		el = @_getTipElement()
		el.delegate('.tour-close', 'click', @onClickClose)
		el.delegate('.tour-next', 'click', @onClickNext)


		that = @

		cont = $('body')

		cont.keyup (e) ->

			visable = el.is(":visible"); 

			key = e.which

			if e.target.nodeName != 'INPUT' and e.target.nodeName != 'TEXTAREA'

				if visable
					if key == 39 # Right 
						that.onClickNext()
					else if key == 27 # esc
						that.onClickClose()

					if key == 39 or key == 27 
						e.preventDefault()

			false

	# Set the current target
	#
	# target - a jquery element that this flyout should point to.
	# step - step object
	#
	# Return nothing
	_setTarget: (target, step) ->
		@cleanupCurrentTarget()

		if target and step and step.highlightTarget
			target.addClass(@highlightClass)
			
			if step.highlightClass?

				@addedHightlightClasses = step.highlightClass

				target.addClass(step.highlightClass)

		@target = target

	# Set z-index on the tip element.
	#
	# zIndex - the z-index desired; falsy val will clear it.
	_setZIndex: (zIndex) ->
		el = @_getTipElement()
		el.css('z-index', zIndex or '')

	# Will build the element that has all the content for the current step
	#
	# step - the step object for the current step
	#
	# Returns a jquery object with all the content.
	_buildContentElement: (step) ->
		buttons = @_buildButtons(step)

		content = $($.parseHTML(@template(
			content: step.content
			buttons: buttons
			close_button: @_buildCloseButton(step)
			counter: if step.final then '' else "step #{step.index+1} of #{step.total}"
			counter_class: if step.final then 'final' else ''
		)))
		content.find('.tour-buttons').addClass('no-buttons') unless buttons

		@_renderActionLabels(content)

		content

	# Create buttons based on step options.
	#
	# Returns a string of button html to be placed into the template.
	_buildButtons: (step) ->
		buttons = ''

		buttons += @okButtonTemplate if step.okButton
		buttons += @skipButtonTemplate if step.skipButton

		if step.nextButton
			buttons += if step.final then @finalButtonTemplate else @nextButtonTemplate

		buttons

	_buildCloseButton: (step) ->

		closeButton = @closeButtonTemplate

		closeClass = @closeButtonClasses

		closeClass += ' ' + step.closeButtonClass if step.closeButtonClass

		closeButton = closeButton.replace /<%= classes %>/, closeClass

		if step.closeButton then closeButton else ''

	_buildCover: (step) ->

		coverDiv = @coverTemplate

		coverClass = @touristCoverClasses

		coverClass += ' ' + step.coverClass if step.coverClass

		coverDiv = coverDiv.replace /<%= classes %>/, coverClass

		if step.cover then coverDiv else ''


	_renderActionLabels: (el) ->
		actions = el.find('.action')
		actionIndex = 0
		for action in actions
			label = $($.parseHTML(@actionLabelTemplate(label: @actionLabels[actionIndex])))
			label.insertBefore(action)
			actionIndex++

	# Caches this tip for destroying it later.
	@_cacheTip: (tip) ->
		Tourist.Tip.Base._cachedTips = [] unless Tourist.Tip.Base._cachedTips
		Tourist.Tip.Base._cachedTips.push(tip)

	# Destroy all tips. Useful in tests.
	@destroy: ->
		return unless Tourist.Tip.Base._cachedTips
		for tip in Tourist.Tip.Base._cachedTips
			tip.destroy()
		Tourist.Tip.Base._cachedTips = null


###
Bootstrap based tip implementation
###
class Tourist.Tip.Bootstrap extends Tourist.Tip.Base

  initialize: (options) ->
    defs =
      showEffect: null
      hideEffect: null
    @options = _.extend(defs, options)
    @tip = new Tourist.Tip.BootstrapTip(@options)

  destroy: ->
    @tip.destroy()
    super()

  # Show the tip
  show: ->
    if @options.showEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.showEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.show()

  # Hide the tip
  hide: ->
    if @options.hideEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.hideEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.hide()


  ###
  Private
  ###

  # Overridden to get the bootstrap element
  _getTipElement: ->
    @tip.el

  # Set the current target. Overridden to set the target on the tip.
  #
  # target - a jquery element that this flyout should point to.
  # step - step object
  #
  # Return nothing
  _setTarget: (target, step) ->
    super(target, step)
    @tip.setTarget(target)

  # Jam the content into the tip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->
    my = step.my or 'left center'
    at = step.at or 'right center'

    @tip.setContainer(step.container or $('body'))
    @tip.setContent(contentElement)
    @tip.setPosition(step.target or false, my, at)


# One can add more effects by hanging a function from this object, then using
# it in the tipOptions.hideEffect or showEffect. i.e.
#
# @s = new Tourist.Tip.Bootstrap
#   model: m
#   showEffect: 'slidein'
#
Tourist.Tip.Bootstrap.effects =

  # Move tip away from target 80px, then slide it in.
  slidein: (tip, element) ->
    OFFSETS = top: 80, left: 80, right: -80, bottom: -80

    # this is a 'Corner' object. Will give us a top, bottom, etc
    side = tip.my.split(' ')[0]
    side = side or 'top'

    # figure out where to start the animation from
    offset = OFFSETS[side]

    # side must be top or left.
    side = 'top' if side == 'bottom'
    side = 'left' if side == 'right'

    value = parseInt(element.css(side))

    # stop the previous animation
    element.stop()

    # set initial position
    css = {}
    css[side] = value + offset
    element.css(css)
    element.show()

    css[side] = value

    # if they have jquery ui, then use a fancy easing. Otherwise, use a builtin.
    easings = ['easeOutCubic', 'swing', 'linear']
    for easing in easings
      break if $.easing[easing]

    element.animate(css, 300, easing)
    null


###
Simple implementation of tooltip with bootstrap markup.

Almost entirely deals with positioning. Uses the similar method for
positioning as qtip2:

  my: 'top center'
  at: 'bottom center'

###
class Tourist.Tip.BootstrapTip

  template: '''
    <div class="popover tourist-popover">
      <div class="arrow"></div>
      <div class="popover-content"></div>
    </div>
  '''

  FLIP_POSITION:
    bottom: 'top'
    top: 'bottom'
    left: 'right'
    right: 'left'

  constructor: (options) ->
    defs =
      offset: 10
      tipOffset: 10
    @options = _.extend(defs, options)
    @el = $($.parseHTML(@template))
    @hide()

  destroy: ->
    @el.remove()

  show: ->
    @el.show().addClass('visible')

  hide: ->
    @el.hide().removeClass('visible')

  setTarget: (@target) ->
    @_setPosition(@target, @my, @at)

  setPosition: (@target, @my, @at) ->
    @_setPosition(@target, @my, @at)

  setContainer: (container) ->
    container.append(@el)

  setContent: (content) ->
    @_getContentElement().html(content)

  ###
  Private
  ###

  _getContentElement: ->
    @el.find('.popover-content')

  _getTipElement: ->
    @el.find('.arrow')

  # Sets the target and the relationship of the tip to the project.
  #
  # target - target node as a jquery element
  # my - position of the tip e.g. 'top center'
  # at - where to point to the target e.g. 'bottom center'
  _setPosition: (target, my='left center', at='right center') ->
    return unless target

    [clas, shift] = my.split(' ')

    originalDisplay = @el.css('display')

    @el
      .css({ top: 0, left: 0, margin: 0, display: 'table' })
      .removeClass('top').removeClass('bottom')
      .removeClass('left').removeClass('right')
      .addClass(@FLIP_POSITION[clas])

    return unless target

    # unset any old tip positioning
    tip = @_getTipElement().css
      left: ''
      right: ''
      top: ''
      bottom: ''

    if shift != 'center'
      tipOffset =
        left: tip[0].offsetWidth/2
        right: 0
        top: tip[0].offsetHeight/2
        bottom: 0

      css = {}
      css[shift] = tipOffset[shift] + @options.tipOffset
      css[@FLIP_POSITION[shift]] = 'auto'
      tip.css(css)

    targetPosition = @_caculateTargetPosition(at, target)
    tipPosition = @_caculateTipPosition(my, targetPosition)
    position = @_adjustForArrow(my, tipPosition)

    @el.css(position)

    # reset the display so we dont inadvertantly show the tip
    @el.css(display: originalDisplay)

  # Figure out where we need to point to on the target element.
  #
  # myPosition - position string on the target. e.g. 'top left'
  # target - target as a jquery element or an array of coords. i.e. [10,30]
  #
  # returns an object with top and left attrs
  _caculateTargetPosition: (atPosition, target) ->

    if Object.prototype.toString.call(target) == '[object Array]'
      return {left: target[0], top: target[1]}

    bounds = @_getTargetBounds(target)
    pos = @_lookupPosition(atPosition, bounds.width, bounds.height)

    return {
      left: bounds.left + pos[0]
      top: bounds.top + pos[1]
    }

  # Position the tip itself to be at the right place in relation to the
  # targetPosition.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # targetPosition - where to point to on the target element. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _caculateTipPosition: (myPosition, targetPosition) ->
    width = @el[0].offsetWidth
    height = @el[0].offsetHeight
    pos = @_lookupPosition(myPosition, width, height)

    return {
      left: targetPosition.left - pos[0]
      top: targetPosition.top - pos[1]
    }

  # Just adjust the tip position to make way for the arrow.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # tipPosition - proper position for the whole tip. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _adjustForArrow: (myPosition, tipPosition) ->
    [clas, shift] = myPosition.split(' ') # will be top, left, right, or bottom

    tip = @_getTipElement()
    width = tip[0].offsetWidth
    height = tip[0].offsetHeight

    position =
      top: tipPosition.top
      left: tipPosition.left

    # adjust the main direction
    switch clas
      when 'top'
        position.top += height+@options.offset
      when 'bottom'
        position.top -= height+@options.offset
      when 'left'
        position.left += width+@options.offset
      when 'right'
        position.left -= width+@options.offset

    # shift the tip
    switch shift
      when 'left'
        position.left -= width/2+@options.tipOffset
      when 'right'
        position.left += width/2+@options.tipOffset
      when 'top'
        position.top -= height/2+@options.tipOffset
      when 'bottom'
        position.top += height/2+@options.tipOffset

    position

  # Figure out how much to shift based on the position string
  #
  # position - position string like 'top left'
  # width - width of the thing
  # height - height of the thing
  #
  # returns a list: [left, top]
  _lookupPosition: (position, width, height) ->
    width2 = width/2
    height2 = height/2

    posLookup =
      'top left': [0,0]
      'left top': [0,0]
      'top right': [width,0]
      'right top': [width,0]
      'bottom left': [0,height]
      'left bottom': [0,height]
      'bottom right': [width,height]
      'right bottom': [width,height]

      'top center': [width2,0]
      'left center': [0,height2]
      'right center': [width,height2]
      'bottom center': [width2,height]

    posLookup[position]

  # Returns the boundaries of the target element
  #
  # target - a jquery element
  _getTargetBounds: (target) ->
    el = target[0]

    if typeof el.getBoundingClientRect == 'function'
      size = el.getBoundingClientRect()
    else
      size =
        width: el.offsetWidth
        height: el.offsetHeight

    $.extend({}, size, target.offset())



###
Qtip based tip implementation
###
class Tourist.Tip.QTip extends Tourist.Tip.Base

  TIP_WIDTH = 6
  TIP_HEIGHT = 14
  ADJUST = 10

  OFFSETS =
    top: 80
    left: 80
    right: -80
    bottom: -80

  # defaults for the qtip flyout.
  QTIP_DEFAULTS:
    content:
      text: ' '
    show:
      ready: false
      delay: 0
      effect: (qtip) ->
        el = $(this)

        # this is a 'Corner' object. Will give us a top, bottom, etc
        side = qtip.options.position.my
        side = side[side.precedance] if side
        side = side or 'top'

        # figure out where to start the animation from
        offset = OFFSETS[side]

        # side must be top or left.
        side = 'top' if side == 'bottom'
        side = 'left' if side == 'right'

        value = parseInt(el.css(side))

        # set initial position
        css = {}
        css[side] = value + offset
        el.css(css)
        el.show()

        css[side] = value
        el.animate(css, 300, 'easeOutCubic')
        null

      autofocus: false
    hide:
      event: null
      delay: 0
      effect: false
    position:
      # set target
      # set viewport to viewport
      adjust:
        method: 'shift shift'
        scroll: false
    style:
      classes: 'ui-tour-tip',
      tip:
        height: TIP_WIDTH,
        width: TIP_HEIGHT
    events: {}
    zindex: 2000

  # Options support everything qtip supports.
  initialize: (options) ->
    options = $.extend(true, {}, @QTIP_DEFAULTS, options)
    @el.qtip(options)
    @qtip = @el.qtip('api')
    @qtip.render()

  destroy: ->
    @qtip.destroy() if @qtip
    super()

  # Show the tip
  show: ->
    @qtip.show()

  # Hide the tip
  hide: ->
    @qtip.hide()


  ###
  Private
  ###

  # Overridden to get the qtip element
  _getTipElement: ->
    $('#qtip-'+@qtip.id)

  # Override to set the target on the qtip
  _setTarget: (targetElement, step) ->
    super(targetElement, step)
    @qtip.set('position.target', targetElement or false)

  # Jam the content into the qtip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->

    my = step.my or 'left center'
    at = step.at or 'right center'

    @_adjustPlacement(my, at)

    @qtip.set('content.text', contentElement)
    @qtip.set('position.container', step.container or $('body'))
    @qtip.set('position.my', my)
    @qtip.set('position.at', at)

    # viewport should be set before target.
    @qtip.set('position.viewport', step.viewport or false)
    @qtip.set('position.target', step.target or false)

    setTimeout( =>
      @_renderTipBackground(my.split(' ')[0])
    , 10)

  # Adjust the placement of the flyout based on its positioning relative to
  # the target. Tip placement and position adjustment is unhandled by qtip. It
  # does provide settings for adjustment, so we use those.
  #
  # my - string like 'top center'. Position of the tip on the flyout.
  # at - string like 'top center'. Place where the tip points on the target.
  #
  # Return nothing
  _adjustPlacement: (my, at) ->
    # issue is that when tip is on left, it needs to be taller than wide, but
    # when on top it should be wider than tall. We're accounting for this
    # here.

    if my.indexOf('top') == 0
      @_adjust(0, ADJUST)

    else if my.indexOf('bottom') == 0
      @_adjust(0, -ADJUST)

    else if my.indexOf('right') == 0
      @_adjust(-ADJUST, 0)

    else
      @_adjust(ADJUST, 0)

  # Set the qtip style properties for tip size and offset.
  _adjust: (adjustX, adjusty) ->
    @qtip.set('position.adjust.x', adjustX)
    @qtip.set('position.adjust.y', adjusty)

  # Add an icon for the tip. Their canvas tips suck. This way we can have a
  # shadow on the tip.
  #
  # direction - string like 'left', 'top', etc. Placement of the tip.
  #
  # Return Nothing
  _renderTipBackground: (direction) =>
    el = $('#qtip-'+@qtip.id+' .qtip-tip')
    bg = el.find('.qtip-tip-bg')
    unless bg.length
      bg = $('<div/>', {'class': 'icon icon-tip qtip-tip-bg'})
      el.append(bg)

    bg.removeClass('top left right bottom')
    bg.addClass(direction)

###
Simplest implementation of a tooltip. Used in the tests. Useful as an example
as well.
###
class Tourist.Tip.Simple extends Tourist.Tip.Base
  initialize: (options) ->
    $('body').append(@el)

  # Show the tip
  show: ->
    @el.show()

  # Hide the tip
  hide: ->
    @el.hide()

  _getTipElement: ->
    @el

  # Jam the content into our element
  _renderContent: (step, contentElement) ->
    @el.html(contentElement)
###

A way to make a tour. Basically, you specify a series of steps which explain
elements to point at and what to say. This class manages moving between those
steps.

The 'step object' is a simple js obj that specifies how the step will behave.

A simple Example of a step object:
  {
    content: '<p>Welcome to my step</p>'
    target: $('#something-to-point-at')
    closeButton: true
    highlightTarget: true
    setup: (tour, options) ->
      # do stuff in the interface/bind
    teardown: (tour, options) ->
      # remove stuff/unbind
  }

Basic Step object options:

  content - a string of html to put into the step.
  target - jquery object or absolute point: [10, 30]
  highlightTarget - optional bool, true will outline the target with a bright color.
  container - optional jquery element that should contain the step flyout.
              default: $('body')
  viewport - optional jquery element that the step flyout should stay within.
             $(window) is commonly used. default: false

  my - string position of the pointer on the tip. default: 'left center'
  at - string position on the element the tip points to. default: 'right center'
  see http://craigsworks.com/projects/qtip2/docs/position/#basics

Step object button options:

  okButton - optional bool, true will show a red ok button
  closeButton - optional bool, true will show a grey close button
  skipButton - optional bool, true will show a grey skip button
  nextButton - optional bool, true will show a red next button

Step object function options:

  All functions on the step will have the signature '(tour, options) ->'

    tour - the Draw.Tour object. Handy to call tour.next()
    options - the step options. An object passed into the tour when created.
              It has the environment that the fns can use to manipulate the
              interface, bind to events, etc. The same object is passed to all
              of a step object's functions, so it is handy for passing data
              between steps.

  setup - called before step is shown. Use to scroll to your target, hide/show things, ...

    'this' is the step object itself.

    MUST return an object. Properties in the returned object will override
    properties in the step object.

    i.e. the target might be dynamic so you would specify:

    setup: (tour, options) ->
      return { target: $('#point-to-me') }

  teardown - function called right before hiding the step. Use to unbind from
    things you bound to in setup().

    'this' is the step object itself.

    Return nothing.

  bind - an array of function names to bind. Use this for event handlers you use in setup().

    Will bind functions to the step object as this, and the first 2 args as tour and options.

    i.e.

    bind: ['onChangeSomething']
    setup: (tour, options) ->
      options.document.bind('change:something', @onChangeSomething)
    onChangeSomething: (tour, options, model, value) ->
      tour.next()
    teardown: (tour, options) ->
      options.document.unbind('change:something', @onChangeSomething)

###
class Tourist.Tour
  _.extend(@prototype, Backbone.Events)

  # options - tour options
  #   stepOptions - an object of options to be passed to each function called on a step object
  #   tipClass - the class from the Tourist.Tip namespace to use
  #   tipOptions - an object passed to the tip
  #   steps - array of step objects
  #   cancelStep - step object for a step that runs if hit the close button.
  #   successStep - step object for a step that runs last when they make it all the way through.
  constructor: (@options={}) ->
    defs =
      tipClass: 'Bootstrap'
    @options = _.extend(defs, @options)

    @model = new Tourist.Model
      current_step: null

    # there is only one tooltip. It will rerender for each step
    tipOptions = _.extend({model: @model}, @options.tipOptions)
    @view = new Tourist.Tip[@options.tipClass](tipOptions)

    @view.bind('click:close', _.bind(@stop, this, true))
    @view.bind('click:next', @next)

    @model.bind('change:current_step', @onChangeCurrentStep)


  ###
  Public
  ###

  # Starts the tour
  #
  # Return nothing
  start: ->
    @trigger('start', this)
    @next()

  # Resets the data and runs the final step
  #
  # doFinalStep - bool whether or not you want to run the final step
  #
  # Return nothing
  stop: (doFinalStep) ->
    if doFinalStep
      @_showCancelFinalStep()
    else
      @_stop()

  # Move to the next step
  #
  # Return nothing
  next: =>
    currentStep = @_teardownCurrentStep()

    index = 0
    index = currentStep.index+1 if currentStep

    if index < @options.steps.length
      @_showStep(@options.steps[index], index)
    else if index == @options.steps.length
      @_showSuccessFinalStep()
    else
      @_stop()

  # Set the stepOptions which is basically like the state for the tour.
  setStepOptions: (stepOptions) ->
    @options.stepOptions = stepOptions


  ###
  Handlers
  ###

  # Called when the current step changes on the model.
  onChangeCurrentStep: (model, step) =>
    @view.render(step)

  ###
  Private
  ###

  # Show the cancel final step - they closed it at some point.
  #
  # Return nothing
  _showCancelFinalStep: ->
    @_showFinalStep(false)

  # Show the success final step - they made it all the way through.
  #
  # Return nothing
  _showSuccessFinalStep: ->
    @_showFinalStep(true)

  # Teardown the current step.
  #
  # Returns the current step after teardown
  _teardownCurrentStep: ->
    currentStep = @model.get('current_step')
    @_teardownStep(currentStep)
    currentStep

  # Stop the tour and reset the state.
  #
  # Return nothing
  _stop: ->
    @_teardownCurrentStep()
    @model.set(current_step: null)
    @trigger('stop', this)

  # Shows a final step.
  #
  # success - bool whether or not to show the success final step. False shows
  #   the cancel final step.
  #
  # Return nothing
  _showFinalStep: (success) ->

    currentStep = @_teardownCurrentStep()

    finalStep = if success then @options.successStep else @options.cancelStep

    if _.isFunction(finalStep)
      finalStep.call(this, this, @options.stepOptions)
      finalStep = null

    return @_stop() unless finalStep
    return @_stop() if currentStep and currentStep.final

    finalStep.final = true
    @_showStep(finalStep, @options.steps.length)

  # Sets step to the current_step in our model. Does all the neccessary setup.
  #
  # step - a step object
  # index - int indexof the step 0 based.
  #
  # Return nothing
  _showStep: (step, index) ->
    return unless step

    step = _.clone(step)
    step.index = index
    step.total = @options.steps.length

    unless step.final
      step.final = (@options.steps.length == index+1 and not @options.successStep)

    # can pass dynamic options from setup
    step = _.extend(step, @_setupStep(step))

    @model.set(current_step: step)

  # Setup an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Returns the return value from step.setup. This will be an object with
  # properties that will override those in the current step object
  _setupStep: (step) ->
    return {} unless step and step.setup

    # bind to any handlers on the step object
    if step.bind
      for fn in step.bind
        step[fn] = _.bind(step[fn], step, this, @options.stepOptions)

    step.setup.call(step, this, @options.stepOptions) or {}

  # Teardown an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Return nothing
  _teardownStep: (step) ->
    step.teardown.call(step, this, @options.stepOptions) if step and step.teardown
    @view.cleanupCurrentTarget()

jasmine.getFixtures().fixturesPath = 'test/fixtures'
jasmine.getStyleFixtures().fixturesPath = 'test/fixtures'

beforeEach ->
  @addMatchers
    toShow: (exp) ->
      actual = this.actual
      actual.css('display') != 'none'

    toHide: (exp) ->
      actual = this.actual
      actual.css('display') == 'none'

window.BasicTipTests = (description, tipGenerator) ->
  describe "Tourist.Tip #{description}", ->
    beforeEach ->
      loadFixtures('tour.html')

      @model = new Tourist.Model
        current_step: null

      @s = tipGenerator.call(this)

    afterEach ->
      Tourist.Tip.Base.destroy()

    describe 'basics', ->
      it 'inits', ->
        expect(@s.options.model instanceof Tourist.Model).toEqual(true)

    describe 'setTarget()', ->
      it 'will set the @target', ->
        el = $('#target-one')
        @s.setTarget(el, {})
        expect(@s.target).toEqual(el)

      it 'will highlight the @target', ->
        el = $('#target-one')
        @s.setTarget(el, {highlightTarget: true})
        expect(el).toHaveClass(@s.highlightClass)

      it 'will highlight the @target', ->
        el = $('#target-one')
        @s.setTarget(el, {highlightTarget: false})
        expect(el).not.toHaveClass(@s.highlightClass)


BasicTipTests 'with Tourist.Tip.Simple', ->
  new Tourist.Tip.Simple
    model: @model


BasicTipTests 'with Tourist.Tip.Bootstrap', ->
  new Tourist.Tip.Bootstrap
    model: @model

BasicTourTests 'with Tourist.Tip.Bootstrap', ->
  new Tourist.Tour
    stepOptions: @options
    steps: @steps
    cancelStep: @finalQuit
    successStep: @finalSucceed
    tipClass: 'Bootstrap'

describe "Tourist.Tip.Bootstrap", ->
  beforeEach ->
    loadFixtures('tour.html')

    @model = new Tourist.Model()
    @s = new Tourist.Tip.Bootstrap
      model: @model

  afterEach ->
    @s.destroy()

  describe 'hide/show', ->
    it 'slidein effect runs', ->
      spyOn(Tourist.Tip.Bootstrap.effects, 'slidein').andCallThrough()
      @s.options.showEffect = 'slidein'
      el = $('#target-one')
      @s.tip.setPosition(el, 'top center', 'bottom center')
      @s.show()
      expect(Tourist.Tip.Bootstrap.effects.slidein).toHaveBeenCalled()

    it 'show works with an effect', ->
      Tourist.Tip.Bootstrap.effects.showeff = jasmine.createSpy()

      @s.options.showEffect = 'showeff'
      @s.show()

      expect(Tourist.Tip.Bootstrap.effects.showeff).toHaveBeenCalled()

    it 'hide works with an effect', ->
      Tourist.Tip.Bootstrap.effects.hideeff = jasmine.createSpy()

      @s.options.hideEffect = 'hideeff'
      @s.hide()

      expect(Tourist.Tip.Bootstrap.effects.hideeff).toHaveBeenCalled()

  describe 'setTarget', ->
    it 'setPosition will not show the tip', ->

      el = $('#target-one')
      @s.tip.setPosition(el, 'top center', 'bottom center')

      spyOn(@s.tip, '_setPosition')

      @s.setTarget([10,20], {})

      expect(@s.tip._setPosition).toHaveBeenCalledWith([10,20], 'top center', 'bottom center')

# Only test the basic things here. Positioning of the popover and the arrow is
# hard to test in code. There is an html file in examples/bootstrap-position-
# test.html to test all the positions.
describe "Tourist.Tip.BootstrapTip", ->
  beforeEach ->
    loadFixtures('tour.html')

    @s = new Tourist.Tip.BootstrapTip()

  afterEach ->
    @s.destroy()

  describe 'hide/show', ->
    it 'initially hidden', ->
      expect(@s.el).toHide()

    it 'hide works', ->
      @s.show()
      @s.hide()
      expect(@s.el).toHide()

    it 'show works', ->
      @s.show()
      expect(@s.el).toShow()

  describe 'positioning', ->
    it 'setPosition will not show the tip', ->
      expect(@s.el).toHide()

      el = $('#target-one')
      @s.setPosition(el, 'top center', 'bottom center')

      expect(@s.el).toHide()

    it 'setPosition keeps the tip shown', ->
      @s.show()

      el = $('#target-one')
      @s.setPosition(el, 'top center', 'bottom center')

      expect(@s.el).toShow()

    it 'setPosition handles an absolute point', ->
      @s.show()

      @s.setPosition([20, 30], 'top left', null)

      expect(@s.el.css('top')).toEqual('40px')
      expect(@s.el.css('left')).toEqual('10px')

BasicTipTests 'with Tourist.Tip.QTip', ->
  new Tourist.Tip.QTip
    model: @model
    content:
      text: '.'

BasicTourTests 'with Tourist.Tip.QTip', ->
  new Tourist.Tour
    stepOptions: @options
    steps: @steps
    cancelStep: @finalQuit
    successStep: @finalSucceed
    tipClass: 'QTip'
    tipOptions:
      content:
        text: '.'

describe "Tourist.Tip.QTip specific", ->
  beforeEach ->
    loadFixtures('tour.html')

    @model = new Tourist.Model
      current_step: null

    @s = new Tourist.Tip.QTip
      model: @model
      content:
        text: '.'

  afterEach ->
    Tourist.Tip.Base.destroy()

  describe 'setTarget()', ->
    it 'will set the @target', ->
      el = $('#target-one')
      @s.setTarget(el, {})

      target = @s.qtip.get('position.target')
      expect(target).toEqual(el)

window.BasicTourTests = (description, tourGenerator) ->
  describe "Tourist.Tour #{description}", ->
    beforeEach ->
      loadFixtures('tour.html')

      @options =
        this: 1
        that: 34

      @steps = [{
        content: '''
          <p class="one">One</p>
        '''
        target: $('#target-one')
        highlightTarget: true
        closeButton: true
        nextButton: true
        setup: (tour, options) ->
        teardown: ->
      },{
        content: '''
          <p class="two">Step Two</p>
        '''
        closeButton: true
        skipButton: true
        setup: ->
          {target: $('#target-two')}
        teardown: ->
      },{
        content: '''
          <p class="three action">Step Three</p>
        '''
        closeButton: true
        nextButton: true
        setup: ->
        teardown: ->
      }]

      @finalQuit =
        content: '''
          <p class="finalquit">The user quit early</p>
        '''
        okButton: true
        target: $('#target-one')
        setup: ->
        teardown: ->

      @finalSucceed =
        content: '''
          <p class="finalsuccess">User made it all the way through</p>
        '''
        okButton: true
        target: $('#target-one')
        setup: ->
        teardown: ->

      @s = tourGenerator.call(this)

    afterEach ->
      Tourist.Tip.Base.destroy()

    describe 'basics', ->
      it 'inits', ->
        expect(@s.model instanceof Tourist.Model).toEqual(true)
        expect(@s.view instanceof Tourist.Tip[@s.options.tipClass]).toEqual(true)

    describe 'rendering', ->
      it 'starts and updates the view', ->
        @s.start()
        @s.next()
        @s.next()

        el = @s.view._getTipElement()
        expect(el.find('.action')).toExist()
        expect(el.find('.action-label')).toExist()
        expect(el.find('.action-label').text()).toEqual('Do this:')

    describe 'zIndex parameter', ->
      it 'uses specified z-index', ->
        @steps[0].zIndex = 4000
        @s.start()
        el = @s.view._getTipElement()
        expect(el.attr('style')).toContain('z-index: 4000')

      it 'clears z-index when not specified', ->
        @steps[0].zIndex = 4000
        @s.start()
        @s.next()
        el = @s.view._getTipElement()
        expect(el.attr('style')).not.toContain('z-index: 4000')

    describe 'stepping', ->
      it 'starts and updates the model', ->
        expect(@s.model.get('current_step')).toEqual(null)

        @s.start()

        expect(@s.model.get('current_step')).not.toEqual(null)
        expect(@s.model.get('current_step').index).toEqual(0)

      it 'starts and updates the view', ->
        @s.start()
        el = @s.view._getTipElement()
        expect(el).toShow()
        expect(el.find('.one')).toExist()
        expect(el.find('.two')).not.toExist()

        expect(el.find('.tour-counter').text()).toEqual('step 1 of 3')

      it 'calls setup', ->
        spyOn(@steps[0], 'setup')

        @s.start()

        expect(@steps[0].setup).toHaveBeenCalledWith(@s, @options)

      it 'calls teardown', ->
        spyOn(@steps[0], 'teardown')
        spyOn(@steps[1], 'setup')

        @s.start()
        @s.next()

        expect(@steps[0].teardown).toHaveBeenCalledWith(@s, @options)
        expect(@steps[1].setup).toHaveBeenCalledWith(@s, @options)

      it 'moves to the next step', ->
        @s.start()
        @s.next()

        expect(@s.model.get('current_step').index).toEqual(1)

        el = @s.view._getTipElement()
        expect(el).toShow()
        expect(el.find('.one')).not.toExist()
        expect(el.find('.two')).toExist()

      it 'calls the final step when through all steps', ->
        @s.start()
        @s.next()
        @s.next()
        expect(@s.model.get('current_step').final).toEqual(false)

        @s.next()
        expect(@s.model.get('current_step').index).toEqual(3)
        expect(@s.model.get('current_step').final).toEqual(true)

        el = @s.view._getTipElement()
        expect(el).toShow()
        expect(el.find('.three')).not.toExist()
        expect(el.find('.finalsuccess')).toExist()

      it 'last step is final when no successStep', ->
        @s.options.successStep = null

        @s.start()
        @s.next()
        @s.next()

        expect(@s.model.get('current_step').index).toEqual(2)
        expect(@s.model.get('current_step').final).toEqual(true)

      it 'calls the function when successStep is just a function', ->
        callback = jasmine.createSpy()
        @s.options.successStep = callback

        @s.start()
        @s.next()
        @s.next()
        @s.next()

        expect(callback).toHaveBeenCalled()

      it 'stops after the final step', ->
        @s.start()
        @s.next()
        @s.next()
        @s.next()
        @s.next()

        expect(@s.model.get('current_step')).toEqual(null)

        el = @s.view._getTipElement()
        #expect(el).toHide() # no worky in qtip tests. Works in real life.

      it 'targets an element returned from setup', ->
        @s.start()
        @s.next()

        expect(@s.view.target[0]).toEqual($('#target-two')[0])

      it 'highlights and unhighlights when neccessary', ->
        @s.start()

        expect($('#target-one')).toHaveClass('tour-highlight')

        @s.next()

        expect($('#target-two')).not.toHaveClass('tour-highlight')
        expect($('#target-one')).not.toHaveClass('tour-highlight')

    describe 'stop()', ->
      it 'pops final cancel step when I pass it true', ->
        @s.start()
        @s.next()
        @s.stop(true)

        expect(@s.model.get('current_step').final).toEqual(true)

        el = @s.view._getTipElement()
        expect(el.find('.finalquit')).toExist()

      it 'actually stops when I pass falsy value', ->
        @s.start()
        @s.next()
        @s.stop()

        expect(@s.model.get('current_step')).toEqual(null)

      it 'unhighlights current thing', ->
        @s.start()
        @s.stop()
        expect(@s.model.get('current_step')).toEqual(null)
        expect($('#target-one')).not.toHaveClass('tour-highlight')

      it 'called when final step open will really stop', ->
        @s.start()
        @s.next()
        @s.stop(true)
        @s.stop(true)

        expect(@s.model.get('current_step')).toEqual(null)

      it 'handles case when no final step', ->
        @s.options.cancelStep = null

        @s.start()
        @s.next()
        @s.stop(true)

        expect(@s.model.get('current_step')).toEqual(null)

      it 'calls teardown on step before final', ->
        spyOn(@steps[1], 'teardown')
        spyOn(@finalQuit, 'setup')

        @s.start()
        @s.next()
        @s.stop(true)

        expect(@steps[1].teardown).toHaveBeenCalledWith(@s, @options)
        expect(@finalQuit.setup).toHaveBeenCalledWith(@s, @options)

      it 'calls teardown on final', ->
        spyOn(@finalQuit, 'teardown')

        @s.start()
        @s.next()
        @s.stop(true)
        @s.stop(true)

        expect(@finalQuit.teardown).toHaveBeenCalledWith(@s, @options)

    describe 'interaction with view buttons', ->

      it 'handles next button', ->
        @s.start()
        @s.view.onClickNext({})
        expect(@s.model.get('current_step').index).toEqual(1)

      it 'handles close button', ->
        @s.start()
        @s.view.onClickClose({})
        expect(@s.model.get('current_step').final).toEqual(true)

        @s.view.onClickClose({})
        expect(@s.model.get('current_step')).toEqual(null)

    describe 'events', ->
      it 'emits a start event', ->
        spy = jasmine.createSpy()
        @s.bind('start', spy)
        @s.start()
        expect(spy).toHaveBeenCalled()

      it 'emits a stop event', ->
        spy = jasmine.createSpy()
        @s.bind('stop', spy)
        @s.start()
        @s.next()
        @s.stop(false)
        expect(spy).toHaveBeenCalled()

BasicTourTests 'with Tourist.Tip.Simple', ->
  new Tourist.Tour
    stepOptions: @options
    steps: @steps
    cancelStep: @finalQuit
    successStep: @finalSucceed
    tipClass: 'Simple'

window.Tourist = window.Tourist or {}

###
A model for the Tour. We'll only use the 'current_step' property.
###
class Tourist.Model extends Backbone.Model
  _module: 'Tourist'
# Just the tip, just to see how it feels.
window.Tourist.Tip = window.Tourist.Tip or {}


###
The flyout showing the content of each step.

This is the base class containing most of the logic. Can extend for different
tooltip implementations.
###
class Tourist.Tip.Base
	_module: 'Tourist'
	_.extend @prototype, Backbone.Events

	visable: false

	# You can override any of thsee templates for your own stuff
	skipButtonTemplate: '<button class="btn btn-default btn-sm pull-right tour-next">Skip this step →</button>'
	nextButtonTemplate: '<button class="btn btn-primary btn-sm pull-right tour-next">Next step →</button>'
	finalButtonTemplate: '<button class="btn btn-primary btn-sm pull-right tour-next">Finish up</button>'

	closeButtonTemplate: '<a class="btn btn-close tour-close" href="#"><i class="<%= classes %>"></i></a>'
	okButtonTemplate: '<button class="btn btn-sm tour-close btn-primary">Okay</button>'
	coverTemplate: '<div class="<%= classes %>" tabindex="1"></div>'

	actionLabelTemplate: _.template '<h4 class="action-label"><%= label %></h4>'
	actionLabels: ['Do this:', 'Then this:', 'Next this:']

	highlightClass: 'tour-highlight'
	closeButtonClasses: 'icon icon-remove'
	touristCoverClasses: 'tourist-cover'

	addedHightlightClasses: undefined

	template: _.template '''
		<div>
			<div class="tour-container">
				<%= close_button %>
				<%= content %>
				<p class="tour-counter <%= counter_class %>"><%= counter%></p>
			</div>
			<div class="tour-buttons">
				<%= buttons %>
			</div>
		</div>
	'''

	# options -
	#   model - a Tourist.Model object
	constructor: (@options={}) ->
		@el = $('<div/>')

		@initialize(options)

		@cover = $.parseHTML(@coverTemplate)

		@_bindClickEvents()

		Tourist.Tip.Base._cacheTip(this)

	destroy: ->
		@el.remove()
		@cover.remove() if @cover?

	# Render the current step as specified by the Tour Model
	#
	# step - step object
	#
	# Return this
	render: (step) ->
		@hide()

		if step
			@_setTarget(step.target or false, step)
			@_setZIndex('')
			@_renderContent(step, @_buildContentElement(step))
			@show() if step.target
			@_setZIndex(step.zIndex, step) if step.zIndex

			cover = @_buildCover(step)
			$('body').append(cover) if step.cover?

			@visible = true

		this

	# Show the tip
	show: ->
		@cover.show().addClass('visible') if @cover?
		# Override me

	# Hide the tip
	hide: ->
		@cover.hide().removeClass('visible') if @cover?
		@visable = false
		# Override me

	# Set the element which the tip will point to
	#
	# targetElement - a jquery element
	# step - step object
	setTarget: (targetElement, step) ->
		@_setTarget(targetElement, step)

	# Unhighlight and unset the current target
	cleanupCurrentTarget: ->
		if @target? and @target.removeClass?
			@target.removeClass(@highlightClass)

			if @addedHightlightClasses?
				@target.removeClass(@addedHightlightClasses) 
				@addedHightlightClasses = undefined

		if @cover? 
			$('.tourist-cover').remove()

		@target = null

	###
	Event Handlers
	###

	# User clicked close or ok button
	onClickClose: (event) =>
		@trigger('click:close', this, event)
		false

	# User clicked next or skip button
	onClickNext: (event) =>
		@trigger('click:next', this, event)
		false


	###
	Private
	###

	# Returns the jquery element that contains all the tip data.
	_getTipElement: ->
		# Override me

	# Place content into your tip's body. Called in render()
	#
	# step - the step object for the current step
	# contentElement - a jquery element containing all the tip's content
	#
	# Returns nothing
	_renderContent: (step, contentElement) ->
		# Override me

	# Bind to the buttons
	_bindClickEvents: ->
		el = @_getTipElement()
		el.delegate('.tour-close', 'click', @onClickClose)
		el.delegate('.tour-next', 'click', @onClickNext)


		that = @

		cont = $('body')

		cont.keyup (e) ->

			visable = el.is(":visible"); 

			key = e.which

			if e.target.nodeName != 'INPUT' and e.target.nodeName != 'TEXTAREA'

				if visable
					if key == 39 # Right 
						that.onClickNext()
					else if key == 27 # esc
						that.onClickClose()

					if key == 39 or key == 27 
						e.preventDefault()

			false

	# Set the current target
	#
	# target - a jquery element that this flyout should point to.
	# step - step object
	#
	# Return nothing
	_setTarget: (target, step) ->
		@cleanupCurrentTarget()

		if target and step and step.highlightTarget
			target.addClass(@highlightClass)
			
			if step.highlightClass?

				@addedHightlightClasses = step.highlightClass

				target.addClass(step.highlightClass)

		@target = target

	# Set z-index on the tip element.
	#
	# zIndex - the z-index desired; falsy val will clear it.
	_setZIndex: (zIndex) ->
		el = @_getTipElement()
		el.css('z-index', zIndex or '')

	# Will build the element that has all the content for the current step
	#
	# step - the step object for the current step
	#
	# Returns a jquery object with all the content.
	_buildContentElement: (step) ->
		buttons = @_buildButtons(step)

		content = $($.parseHTML(@template(
			content: step.content
			buttons: buttons
			close_button: @_buildCloseButton(step)
			counter: if step.final then '' else "step #{step.index+1} of #{step.total}"
			counter_class: if step.final then 'final' else ''
		)))
		content.find('.tour-buttons').addClass('no-buttons') unless buttons

		@_renderActionLabels(content)

		content

	# Create buttons based on step options.
	#
	# Returns a string of button html to be placed into the template.
	_buildButtons: (step) ->
		buttons = ''

		buttons += @okButtonTemplate if step.okButton
		buttons += @skipButtonTemplate if step.skipButton

		if step.nextButton
			buttons += if step.final then @finalButtonTemplate else @nextButtonTemplate

		buttons

	_buildCloseButton: (step) ->

		closeButton = @closeButtonTemplate

		closeClass = @closeButtonClasses

		closeClass += ' ' + step.closeButtonClass if step.closeButtonClass

		closeButton = closeButton.replace /<%= classes %>/, closeClass

		if step.closeButton then closeButton else ''

	_buildCover: (step) ->

		coverDiv = @coverTemplate

		coverClass = @touristCoverClasses

		coverClass += ' ' + step.coverClass if step.coverClass

		coverDiv = coverDiv.replace /<%= classes %>/, coverClass

		if step.cover then coverDiv else ''


	_renderActionLabels: (el) ->
		actions = el.find('.action')
		actionIndex = 0
		for action in actions
			label = $($.parseHTML(@actionLabelTemplate(label: @actionLabels[actionIndex])))
			label.insertBefore(action)
			actionIndex++

	# Caches this tip for destroying it later.
	@_cacheTip: (tip) ->
		Tourist.Tip.Base._cachedTips = [] unless Tourist.Tip.Base._cachedTips
		Tourist.Tip.Base._cachedTips.push(tip)

	# Destroy all tips. Useful in tests.
	@destroy: ->
		return unless Tourist.Tip.Base._cachedTips
		for tip in Tourist.Tip.Base._cachedTips
			tip.destroy()
		Tourist.Tip.Base._cachedTips = null


###
Bootstrap based tip implementation
###
class Tourist.Tip.Bootstrap extends Tourist.Tip.Base

  initialize: (options) ->
    defs =
      showEffect: null
      hideEffect: null
    @options = _.extend(defs, options)
    @tip = new Tourist.Tip.BootstrapTip(@options)

  destroy: ->
    @tip.destroy()
    super()

  # Show the tip
  show: ->
    if @options.showEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.showEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.show()

  # Hide the tip
  hide: ->
    if @options.hideEffect
      fn = Tourist.Tip.Bootstrap.effects[@options.hideEffect]
      fn.call(this, @tip, @tip.el)
    else
      @tip.hide()


  ###
  Private
  ###

  # Overridden to get the bootstrap element
  _getTipElement: ->
    @tip.el

  # Set the current target. Overridden to set the target on the tip.
  #
  # target - a jquery element that this flyout should point to.
  # step - step object
  #
  # Return nothing
  _setTarget: (target, step) ->
    super(target, step)
    @tip.setTarget(target)

  # Jam the content into the tip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->
    my = step.my or 'left center'
    at = step.at or 'right center'

    @tip.setContainer(step.container or $('body'))
    @tip.setContent(contentElement)
    @tip.setPosition(step.target or false, my, at)


# One can add more effects by hanging a function from this object, then using
# it in the tipOptions.hideEffect or showEffect. i.e.
#
# @s = new Tourist.Tip.Bootstrap
#   model: m
#   showEffect: 'slidein'
#
Tourist.Tip.Bootstrap.effects =

  # Move tip away from target 80px, then slide it in.
  slidein: (tip, element) ->
    OFFSETS = top: 80, left: 80, right: -80, bottom: -80

    # this is a 'Corner' object. Will give us a top, bottom, etc
    side = tip.my.split(' ')[0]
    side = side or 'top'

    # figure out where to start the animation from
    offset = OFFSETS[side]

    # side must be top or left.
    side = 'top' if side == 'bottom'
    side = 'left' if side == 'right'

    value = parseInt(element.css(side))

    # stop the previous animation
    element.stop()

    # set initial position
    css = {}
    css[side] = value + offset
    element.css(css)
    element.show()

    css[side] = value

    # if they have jquery ui, then use a fancy easing. Otherwise, use a builtin.
    easings = ['easeOutCubic', 'swing', 'linear']
    for easing in easings
      break if $.easing[easing]

    element.animate(css, 300, easing)
    null


###
Simple implementation of tooltip with bootstrap markup.

Almost entirely deals with positioning. Uses the similar method for
positioning as qtip2:

  my: 'top center'
  at: 'bottom center'

###
class Tourist.Tip.BootstrapTip

  template: '''
    <div class="popover tourist-popover">
      <div class="arrow"></div>
      <div class="popover-content"></div>
    </div>
  '''

  FLIP_POSITION:
    bottom: 'top'
    top: 'bottom'
    left: 'right'
    right: 'left'

  constructor: (options) ->
    defs =
      offset: 10
      tipOffset: 10
    @options = _.extend(defs, options)
    @el = $($.parseHTML(@template))
    @hide()

  destroy: ->
    @el.remove()

  show: ->
    @el.show().addClass('visible')

  hide: ->
    @el.hide().removeClass('visible')

  setTarget: (@target) ->
    @_setPosition(@target, @my, @at)

  setPosition: (@target, @my, @at) ->
    @_setPosition(@target, @my, @at)

  setContainer: (container) ->
    container.append(@el)

  setContent: (content) ->
    @_getContentElement().html(content)

  ###
  Private
  ###

  _getContentElement: ->
    @el.find('.popover-content')

  _getTipElement: ->
    @el.find('.arrow')

  # Sets the target and the relationship of the tip to the project.
  #
  # target - target node as a jquery element
  # my - position of the tip e.g. 'top center'
  # at - where to point to the target e.g. 'bottom center'
  _setPosition: (target, my='left center', at='right center') ->
    return unless target

    [clas, shift] = my.split(' ')

    originalDisplay = @el.css('display')

    @el
      .css({ top: 0, left: 0, margin: 0, display: 'table' })
      .removeClass('top').removeClass('bottom')
      .removeClass('left').removeClass('right')
      .addClass(@FLIP_POSITION[clas])

    return unless target

    # unset any old tip positioning
    tip = @_getTipElement().css
      left: ''
      right: ''
      top: ''
      bottom: ''

    if shift != 'center'
      tipOffset =
        left: tip[0].offsetWidth/2
        right: 0
        top: tip[0].offsetHeight/2
        bottom: 0

      css = {}
      css[shift] = tipOffset[shift] + @options.tipOffset
      css[@FLIP_POSITION[shift]] = 'auto'
      tip.css(css)

    targetPosition = @_caculateTargetPosition(at, target)
    tipPosition = @_caculateTipPosition(my, targetPosition)
    position = @_adjustForArrow(my, tipPosition)

    @el.css(position)

    # reset the display so we dont inadvertantly show the tip
    @el.css(display: originalDisplay)

  # Figure out where we need to point to on the target element.
  #
  # myPosition - position string on the target. e.g. 'top left'
  # target - target as a jquery element or an array of coords. i.e. [10,30]
  #
  # returns an object with top and left attrs
  _caculateTargetPosition: (atPosition, target) ->

    if Object.prototype.toString.call(target) == '[object Array]'
      return {left: target[0], top: target[1]}

    bounds = @_getTargetBounds(target)
    pos = @_lookupPosition(atPosition, bounds.width, bounds.height)

    return {
      left: bounds.left + pos[0]
      top: bounds.top + pos[1]
    }

  # Position the tip itself to be at the right place in relation to the
  # targetPosition.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # targetPosition - where to point to on the target element. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _caculateTipPosition: (myPosition, targetPosition) ->
    width = @el[0].offsetWidth
    height = @el[0].offsetHeight
    pos = @_lookupPosition(myPosition, width, height)

    return {
      left: targetPosition.left - pos[0]
      top: targetPosition.top - pos[1]
    }

  # Just adjust the tip position to make way for the arrow.
  #
  # myPosition - position string for the tip. e.g. 'top left'
  # tipPosition - proper position for the whole tip. e.g. {top: 20, left: 10}
  #
  # returns an object with top and left attrs
  _adjustForArrow: (myPosition, tipPosition) ->
    [clas, shift] = myPosition.split(' ') # will be top, left, right, or bottom

    tip = @_getTipElement()
    width = tip[0].offsetWidth
    height = tip[0].offsetHeight

    position =
      top: tipPosition.top
      left: tipPosition.left

    # adjust the main direction
    switch clas
      when 'top'
        position.top += height+@options.offset
      when 'bottom'
        position.top -= height+@options.offset
      when 'left'
        position.left += width+@options.offset
      when 'right'
        position.left -= width+@options.offset

    # shift the tip
    switch shift
      when 'left'
        position.left -= width/2+@options.tipOffset
      when 'right'
        position.left += width/2+@options.tipOffset
      when 'top'
        position.top -= height/2+@options.tipOffset
      when 'bottom'
        position.top += height/2+@options.tipOffset

    position

  # Figure out how much to shift based on the position string
  #
  # position - position string like 'top left'
  # width - width of the thing
  # height - height of the thing
  #
  # returns a list: [left, top]
  _lookupPosition: (position, width, height) ->
    width2 = width/2
    height2 = height/2

    posLookup =
      'top left': [0,0]
      'left top': [0,0]
      'top right': [width,0]
      'right top': [width,0]
      'bottom left': [0,height]
      'left bottom': [0,height]
      'bottom right': [width,height]
      'right bottom': [width,height]

      'top center': [width2,0]
      'left center': [0,height2]
      'right center': [width,height2]
      'bottom center': [width2,height]

    posLookup[position]

  # Returns the boundaries of the target element
  #
  # target - a jquery element
  _getTargetBounds: (target) ->
    el = target[0]

    if typeof el.getBoundingClientRect == 'function'
      size = el.getBoundingClientRect()
    else
      size =
        width: el.offsetWidth
        height: el.offsetHeight

    $.extend({}, size, target.offset())



###
Qtip based tip implementation
###
class Tourist.Tip.QTip extends Tourist.Tip.Base

  TIP_WIDTH = 6
  TIP_HEIGHT = 14
  ADJUST = 10

  OFFSETS =
    top: 80
    left: 80
    right: -80
    bottom: -80

  # defaults for the qtip flyout.
  QTIP_DEFAULTS:
    content:
      text: ' '
    show:
      ready: false
      delay: 0
      effect: (qtip) ->
        el = $(this)

        # this is a 'Corner' object. Will give us a top, bottom, etc
        side = qtip.options.position.my
        side = side[side.precedance] if side
        side = side or 'top'

        # figure out where to start the animation from
        offset = OFFSETS[side]

        # side must be top or left.
        side = 'top' if side == 'bottom'
        side = 'left' if side == 'right'

        value = parseInt(el.css(side))

        # set initial position
        css = {}
        css[side] = value + offset
        el.css(css)
        el.show()

        css[side] = value
        el.animate(css, 300, 'easeOutCubic')
        null

      autofocus: false
    hide:
      event: null
      delay: 0
      effect: false
    position:
      # set target
      # set viewport to viewport
      adjust:
        method: 'shift shift'
        scroll: false
    style:
      classes: 'ui-tour-tip',
      tip:
        height: TIP_WIDTH,
        width: TIP_HEIGHT
    events: {}
    zindex: 2000

  # Options support everything qtip supports.
  initialize: (options) ->
    options = $.extend(true, {}, @QTIP_DEFAULTS, options)
    @el.qtip(options)
    @qtip = @el.qtip('api')
    @qtip.render()

  destroy: ->
    @qtip.destroy() if @qtip
    super()

  # Show the tip
  show: ->
    @qtip.show()

  # Hide the tip
  hide: ->
    @qtip.hide()


  ###
  Private
  ###

  # Overridden to get the qtip element
  _getTipElement: ->
    $('#qtip-'+@qtip.id)

  # Override to set the target on the qtip
  _setTarget: (targetElement, step) ->
    super(targetElement, step)
    @qtip.set('position.target', targetElement or false)

  # Jam the content into the qtip's body. Also place the tip along side the
  # target element.
  _renderContent: (step, contentElement) ->

    my = step.my or 'left center'
    at = step.at or 'right center'

    @_adjustPlacement(my, at)

    @qtip.set('content.text', contentElement)
    @qtip.set('position.container', step.container or $('body'))
    @qtip.set('position.my', my)
    @qtip.set('position.at', at)

    # viewport should be set before target.
    @qtip.set('position.viewport', step.viewport or false)
    @qtip.set('position.target', step.target or false)

    setTimeout( =>
      @_renderTipBackground(my.split(' ')[0])
    , 10)

  # Adjust the placement of the flyout based on its positioning relative to
  # the target. Tip placement and position adjustment is unhandled by qtip. It
  # does provide settings for adjustment, so we use those.
  #
  # my - string like 'top center'. Position of the tip on the flyout.
  # at - string like 'top center'. Place where the tip points on the target.
  #
  # Return nothing
  _adjustPlacement: (my, at) ->
    # issue is that when tip is on left, it needs to be taller than wide, but
    # when on top it should be wider than tall. We're accounting for this
    # here.

    if my.indexOf('top') == 0
      @_adjust(0, ADJUST)

    else if my.indexOf('bottom') == 0
      @_adjust(0, -ADJUST)

    else if my.indexOf('right') == 0
      @_adjust(-ADJUST, 0)

    else
      @_adjust(ADJUST, 0)

  # Set the qtip style properties for tip size and offset.
  _adjust: (adjustX, adjusty) ->
    @qtip.set('position.adjust.x', adjustX)
    @qtip.set('position.adjust.y', adjusty)

  # Add an icon for the tip. Their canvas tips suck. This way we can have a
  # shadow on the tip.
  #
  # direction - string like 'left', 'top', etc. Placement of the tip.
  #
  # Return Nothing
  _renderTipBackground: (direction) =>
    el = $('#qtip-'+@qtip.id+' .qtip-tip')
    bg = el.find('.qtip-tip-bg')
    unless bg.length
      bg = $('<div/>', {'class': 'icon icon-tip qtip-tip-bg'})
      el.append(bg)

    bg.removeClass('top left right bottom')
    bg.addClass(direction)

###
Simplest implementation of a tooltip. Used in the tests. Useful as an example
as well.
###
class Tourist.Tip.Simple extends Tourist.Tip.Base
  initialize: (options) ->
    $('body').append(@el)

  # Show the tip
  show: ->
    @el.show()

  # Hide the tip
  hide: ->
    @el.hide()

  _getTipElement: ->
    @el

  # Jam the content into our element
  _renderContent: (step, contentElement) ->
    @el.html(contentElement)
###

A way to make a tour. Basically, you specify a series of steps which explain
elements to point at and what to say. This class manages moving between those
steps.

The 'step object' is a simple js obj that specifies how the step will behave.

A simple Example of a step object:
  {
    content: '<p>Welcome to my step</p>'
    target: $('#something-to-point-at')
    closeButton: true
    highlightTarget: true
    setup: (tour, options) ->
      # do stuff in the interface/bind
    teardown: (tour, options) ->
      # remove stuff/unbind
  }

Basic Step object options:

  content - a string of html to put into the step.
  target - jquery object or absolute point: [10, 30]
  highlightTarget - optional bool, true will outline the target with a bright color.
  container - optional jquery element that should contain the step flyout.
              default: $('body')
  viewport - optional jquery element that the step flyout should stay within.
             $(window) is commonly used. default: false

  my - string position of the pointer on the tip. default: 'left center'
  at - string position on the element the tip points to. default: 'right center'
  see http://craigsworks.com/projects/qtip2/docs/position/#basics

Step object button options:

  okButton - optional bool, true will show a red ok button
  closeButton - optional bool, true will show a grey close button
  skipButton - optional bool, true will show a grey skip button
  nextButton - optional bool, true will show a red next button

Step object function options:

  All functions on the step will have the signature '(tour, options) ->'

    tour - the Draw.Tour object. Handy to call tour.next()
    options - the step options. An object passed into the tour when created.
              It has the environment that the fns can use to manipulate the
              interface, bind to events, etc. The same object is passed to all
              of a step object's functions, so it is handy for passing data
              between steps.

  setup - called before step is shown. Use to scroll to your target, hide/show things, ...

    'this' is the step object itself.

    MUST return an object. Properties in the returned object will override
    properties in the step object.

    i.e. the target might be dynamic so you would specify:

    setup: (tour, options) ->
      return { target: $('#point-to-me') }

  teardown - function called right before hiding the step. Use to unbind from
    things you bound to in setup().

    'this' is the step object itself.

    Return nothing.

  bind - an array of function names to bind. Use this for event handlers you use in setup().

    Will bind functions to the step object as this, and the first 2 args as tour and options.

    i.e.

    bind: ['onChangeSomething']
    setup: (tour, options) ->
      options.document.bind('change:something', @onChangeSomething)
    onChangeSomething: (tour, options, model, value) ->
      tour.next()
    teardown: (tour, options) ->
      options.document.unbind('change:something', @onChangeSomething)

###
class Tourist.Tour
  _.extend(@prototype, Backbone.Events)

  # options - tour options
  #   stepOptions - an object of options to be passed to each function called on a step object
  #   tipClass - the class from the Tourist.Tip namespace to use
  #   tipOptions - an object passed to the tip
  #   steps - array of step objects
  #   cancelStep - step object for a step that runs if hit the close button.
  #   successStep - step object for a step that runs last when they make it all the way through.
  constructor: (@options={}) ->
    defs =
      tipClass: 'Bootstrap'
    @options = _.extend(defs, @options)

    @model = new Tourist.Model
      current_step: null

    # there is only one tooltip. It will rerender for each step
    tipOptions = _.extend({model: @model}, @options.tipOptions)
    @view = new Tourist.Tip[@options.tipClass](tipOptions)

    @view.bind('click:close', _.bind(@stop, this, true))
    @view.bind('click:next', @next)

    @model.bind('change:current_step', @onChangeCurrentStep)


  ###
  Public
  ###

  # Starts the tour
  #
  # Return nothing
  start: ->
    @trigger('start', this)
    @next()

  # Resets the data and runs the final step
  #
  # doFinalStep - bool whether or not you want to run the final step
  #
  # Return nothing
  stop: (doFinalStep) ->
    if doFinalStep
      @_showCancelFinalStep()
    else
      @_stop()

  # Move to the next step
  #
  # Return nothing
  next: =>
    currentStep = @_teardownCurrentStep()

    index = 0
    index = currentStep.index+1 if currentStep

    if index < @options.steps.length
      @_showStep(@options.steps[index], index)
    else if index == @options.steps.length
      @_showSuccessFinalStep()
    else
      @_stop()

  # Set the stepOptions which is basically like the state for the tour.
  setStepOptions: (stepOptions) ->
    @options.stepOptions = stepOptions


  ###
  Handlers
  ###

  # Called when the current step changes on the model.
  onChangeCurrentStep: (model, step) =>
    @view.render(step)

  ###
  Private
  ###

  # Show the cancel final step - they closed it at some point.
  #
  # Return nothing
  _showCancelFinalStep: ->
    @_showFinalStep(false)

  # Show the success final step - they made it all the way through.
  #
  # Return nothing
  _showSuccessFinalStep: ->
    @_showFinalStep(true)

  # Teardown the current step.
  #
  # Returns the current step after teardown
  _teardownCurrentStep: ->
    currentStep = @model.get('current_step')
    @_teardownStep(currentStep)
    currentStep

  # Stop the tour and reset the state.
  #
  # Return nothing
  _stop: ->
    @_teardownCurrentStep()
    @model.set(current_step: null)
    @trigger('stop', this)

  # Shows a final step.
  #
  # success - bool whether or not to show the success final step. False shows
  #   the cancel final step.
  #
  # Return nothing
  _showFinalStep: (success) ->

    currentStep = @_teardownCurrentStep()

    finalStep = if success then @options.successStep else @options.cancelStep

    if _.isFunction(finalStep)
      finalStep.call(this, this, @options.stepOptions)
      finalStep = null

    return @_stop() unless finalStep
    return @_stop() if currentStep and currentStep.final

    finalStep.final = true
    @_showStep(finalStep, @options.steps.length)

  # Sets step to the current_step in our model. Does all the neccessary setup.
  #
  # step - a step object
  # index - int indexof the step 0 based.
  #
  # Return nothing
  _showStep: (step, index) ->
    return unless step

    step = _.clone(step)
    step.index = index
    step.total = @options.steps.length

    unless step.final
      step.final = (@options.steps.length == index+1 and not @options.successStep)

    # can pass dynamic options from setup
    step = _.extend(step, @_setupStep(step))

    @model.set(current_step: step)

  # Setup an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Returns the return value from step.setup. This will be an object with
  # properties that will override those in the current step object
  _setupStep: (step) ->
    return {} unless step and step.setup

    # bind to any handlers on the step object
    if step.bind
      for fn in step.bind
        step[fn] = _.bind(step[fn], step, this, @options.stepOptions)

    step.setup.call(step, this, @options.stepOptions) or {}

  # Teardown an arbitrary step
  #
  # step - a step object from @options.steps
  #
  # Return nothing
  _teardownStep: (step) ->
    step.teardown.call(step, this, @options.stepOptions) if step and step.teardown
    @view.cleanupCurrentTarget()

//# sourceMappingURL=tourist.coffee.map