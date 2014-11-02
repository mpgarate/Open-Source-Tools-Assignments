BEGIN { line = 0 }

{

  line ++;

  printf("%s",$0);

  if (line > 9){
    printf("\n");
    line = 0;
  } else {
    printf(",");
  }

}
END { }