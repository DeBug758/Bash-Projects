# Bash Task 1
Company ABC has uncontrolled process of employee’s accounts creation. Currently process means
adding names, email and other personal data manually to the accounts.csv file without any rules.
Department head has decided to improve it based on the naming convention implementation. Good
idea for newcomers, but what to do with current user’s list? You have been asked to help. Could you please
develop automated way (bash script) and create new accounts_new.csv file based on current
accounts.csv and below.

1. Need to update column name. Name format: first letter of name/surname uppercase and all other letters lowercase.
2. Need to update column email with domain `@abc`. Email format: first letter from name and full surname, lowercase. Equals emails should contain location_id.
3. Sripts should has name task1.sh
4. Path to accounts.csv file should be as argument to the script.
## Definition of done.
Developed bash script which automatically creates accounts_new.csv and updates columns name and
email based on the rules above.
## Example:
```
./task1.sh accounts.csv
```
### was:
```
8,6,Bart charlow,Executive Director,,
9,7,Bart Charlow,Executive Director,,
```
### became:
```
8,6,Bart Charlow,Executive Director,bcharlow6@abc.com,
9,7,Bart Charlow,Executive Director,bcharlow7@abc.com,
```
# Bash Task 2
Company DEF decided to use testing tool for their employees. But current tool has no json output that can be using for later data processing.
1. Need to parce output.txt to convert into output.json:

## Example:
### this is output.txt:
```
[ Asserts Samples ], 1..2 tests
-----------------------------------------------------------------------------------
not ok  1  expecting command finishes successfully (bash way), 7ms
ok  2  expecting command prints some message (the same as above, bats way), 10ms
-----------------------------------------------------------------------------------
1 (of 2) tests passed, 1 tests failed, rated as 50%, spent 17ms
```

### this is output.txt:
```
{
 "testName": "Asserts Samples",
 "tests": [
   {
     "name": "expecting command finishes successfully (bash way)",
     "status": false,
     "duration": "7ms"
   },
   {
     "name": "expecting command prints some message (the same as above, bats way)",
     "status": true,
     "duration": "10ms"
   }
 ],
 "summary": {
   "success": 1,
   "failed": 1,
   "rating": 50,
   "duration": "17ms"
 }
}
```
2. Count of tests can be more than 2
3. Rating is a number and can be float or int (for example 50.23, 50, 100)
4. Sripts should has name task2.sh
5. Path to output.txt file should be as argument to the script.

If you need to use additional tools like `jq` please use it directly from this repository in your script: `./jq`
Also you can use some specific tools in this approach

## Definition of done.
Developed bash script which automatically convert output.txt to json based on the example above.
