library(tidyverse)

ru<- read_csv('C:/Users/00015/Desktop/tidytuesday/levada/ukr_ru/ru_op.csv', skip=2)
ukr<- read_csv('C:/Users/00015/Desktop/tidytuesday/levada/ukr_ru/ukr_op.csv', skip=2)

conflict <- ru %>% 
  bind_rows(ukr)

View(conflict)

conflict$date<- parse_date(conflict$date, '%d/%m/%Y')

conflict

conflict$source <- factor(conflict$source)

conflict %>% 
  transmute(date=date,
            good=v_good+good,
            bad= bad+v_bad,
            dont_know=dont_know,
            source=source) %>% 
  gather(key=measure, value=value,
         good, bad, dont_know) %>% 
  ggplot(aes(x=date, y=value, colour= measure)) +
  geom_point()+
  geom_line()+
  facet_wrap(~source)
