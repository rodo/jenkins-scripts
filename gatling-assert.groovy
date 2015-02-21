def matcher = manager.getLogMatcher(".*(Global: .* response time is less than .*): false\$")
if(matcher?.matches()) {
    manager.addWarningBadge(matcher.group(1) )
    manager.createSummary("warning.gif").appendText(matcher.group(1), false, false, false, "red")
}

def pmatcher = manager.getLogMatcher(".*(Global percentage of requests OK is greater than .*): false\$")
if(pmatcher?.matches()) {
    manager.addWarningBadge(pmatcher.group(1) )
    manager.createSummary("error.gif").appendText(pmatcher.group(1), false, false, false, "red")
}

def fqr = manager.getLogMatcher(".*(Global number of requests KO is equal to .*: false)\$")
if(fqr?.matches()) {
    manager.addWarningBadge(fqr.group(1) )
    manager.createSummary("error.gif").appendText(fqr.group(1), false, false, false, "red")
}

def report = manager.getLogMatcher("&gt;.*(max reponse time .*  generated in .*)s.\$")
if(report?.matches()) {
    manager.createSummary("info.gif").appendText(report.group(1), false, false, false, "black") 
}

def version = manager.getLogMatcher(".*version=(.*) Redirect.*\$")
if(version?.matches()) {
  manager.createSummary("orange-square.png").appendText(version.group(1), false, false, false, "black")
  manager.addShortText(version.group(1))
}
        