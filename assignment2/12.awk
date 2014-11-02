BEGIN { FS=",";}

{
  arr[$1] += 1;

}

END { 
  
  total_states = length(arr);
  total_polls = 0;
  for(state in arr){
    count = arr[state];
    total_polls += count;
  }

  printf("%f\n", (total_polls / total_states));
}
