ini_open("yourchoose.loh")
ini_read_string("whoyou","you","none")
ini_close()
check=get_integer("Введи число от 1 до 3; 1 - \"это обосрался\"; 2 - это \"Умер\"; 3 - это \"Всё сразу\"","")
if check<1{check=1}
if check>1 && check<1.5{check=1}
if check>=1.5 && check<2.5{check=2}
if check>=2.5 && check<3{check=3}
if check>3 {check=3}
if check !=1 && check !=2 && check !=3{alarm[0]=10;check=0}
if check=1{ini_open("yourchoose.loh");ini_write_string("whoyou","you","обосрался");ini_close()}
if check=2{ini_open("yourchoose.loh");ini_write_string("whoyou","you","умер");ini_close()}
if check=3{ini_open("yourchoose.loh");ini_write_string("whoyou","you","обосрался и умер");ini_close()}
show_message("Переименуй расширение созданного файла yourchoose.loh#На yourchoose.txt")

