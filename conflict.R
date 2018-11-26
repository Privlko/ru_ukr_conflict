library(tidyverse)

ru<- read_csv('C:/Users/00015/Desktop/tidytuesday/levada/ukr_ru/ru_op.csv', skip=2)
ukr<- read_csv('C:/Users/00015/Desktop/tidytuesday/levada/ukr_ru/ukr_op.csv', skip=2)

conflict <- ru %>% 
  bind_rows(ukr)

View(conflict)

conflict$date<- parse_date(conflict$date, '%d/%m/%Y')

conflict

conflict$source <- factor(conflict$source)

labels <- c('ru-opinion of ukr' = "Russians on Ukrainians", 'ukr opinion of ru' = "Ukrainians on Russians")


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
  facet_wrap(~source, labeller=labeller(source=labels))+
  labs(title='Russian opinion of Ukraine is steady, \nUkrainian opinion of Russia is Dynamic',
       subtitle= 'Ukrainians recently saw a minor improvement in their attitude towards Russia, \nalthough skepticism also growing.',
       x= 'Date',
       y='') +
  scale_y_continuous(labels = scales::dollar_format(suffix = "%", prefix = "")) +
  scale_colour_discrete(name="Collapsed opinion",
                        breaks=c("bad", "dont_know", "good"),
                        labels=c("Bad", "Don't know", "Good"))+
  theme_minimal()
