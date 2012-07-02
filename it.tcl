package require log

namespace eval ::testcl {
  variable nbOfTestFailures 0
  namespace export it
}

proc ::testcl::reset_expectations { } {
  variable expectations
  if { [info exists expectations] } {
    log::log debug "Reset expectations"
    set expectations {}
  }
  variable expectedEndState
  if { [info exists expectedEndState] } {
    log::log debug "Reset end state"
    unset expectedEndState
  }
  variable expectedEvent
  if { [info exists expectedEvent] } {
    log::log debug "Reset expected event"
    unset expectedEvent
  }
}


proc ::testcl::it {description body} {

  puts "\n**************************************************************************"
  puts "* it $description"
  puts "**************************************************************************"

  ::testcl::reset_expectations
  
  set setItUpList [info commands ::testcl::setItUp]

  if { [llength $setItUpList] == 1 } {
    log::log debug "Calling set it up"
    ::testcl::setItUp
  } else {
    log::log debug "Nothing to set up"
  }

  variable nbOfTestFailures
  set rc [catch $body result]
  
  if {$rc != 0 } {
    puts "-> Test failure!!"
    puts "-> -> $result"
    log::log error $result 
    incr $nbOfTestFailures
  } else {
    puts "-> Test ok"
  }
  
}
