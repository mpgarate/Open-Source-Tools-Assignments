BEGIN { FS=",";}

{

  arr[$1] += 1;

}

END { 
  greatest_state_name = "";
  greatest_count = -1;

  for(state_name in arr){
    count = arr[state_name];
    if (count > greatest_count){
      greatest_state_name = state_name;
      greatest_count = count;
    }
  }

  print(greatest_state_name);
}
