def matcher = manager.getLogMatcher(&quot;.*(Global: .* response time is less than .*): false\$&quot;)
if(matcher?.matches()) {
    manager.addWarningBadge(matcher.group(1) )
    manager.createSummary(&quot;warning.gif&quot;).appendText(matcher.group(1), false, false, false, &quot;red&quot;)
}

def pmatcher = manager.getLogMatcher(&quot;.*(Global percentage of requests OK is greater than .*): false\$&quot;)
if(pmatcher?.matches()) {
    manager.addWarningBadge(pmatcher.group(1) )
    manager.createSummary(&quot;error.gif&quot;).appendText(pmatcher.group(1), false, false, false, &quot;red&quot;)
}

def fqr = manager.getLogMatcher(&quot;.*(Global number of requests KO is equal to .*: false)\$&quot;)
if(fqr?.matches()) {
    manager.addWarningBadge(fqr.group(1) )
    manager.createSummary(&quot;error.gif&quot;).appendText(fqr.group(1), false, false, false, &quot;red&quot;)
}

def report = manager.getLogMatcher(&quot;&gt;.*(max reponse time .*  generated in .*)s.\$&quot;)
if(report?.matches()) {
    manager.createSummary(&quot;info.gif&quot;).appendText(report.group(1), false, false, false, &quot;black&quot;) 
}
