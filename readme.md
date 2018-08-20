# Time subtractor

This ruby command line program takes two lists of time ranges and returns a new list of ranges where the ranges in the second list have been subtracted to the ranges in the first.

## Start the program
```
ruby ruby main.rb
```
It will output on stdout the result of :
(9:00-10:00) “minus” (9:00-9:30)

## Configure testing dependency
```
gem install minitest
```

## Launch tests
```
ruby test_time_subtractor.rb
```
