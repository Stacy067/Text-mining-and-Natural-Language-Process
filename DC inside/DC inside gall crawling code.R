## 한 페이지만 추출 ##

#정치사회갤 첫페이지 추출

url<-'https://gall.dcinside.com/board/lists/?id=stock_new2&page=1'

b<-readLines(url, encoding="UTF-8")

library(stringr)

# 게시글 제목, url 뽑기

index<-which(str_detect(b, "gall_tit ub-word"))[-1]

b2<-b[index+1]

title<-str_trim(str_extract(b2, ("(?<=</em>).*(?=</a>)")))

con_url<-str_sub(str_extract(b2, ("(?<=a  href=).*(?=view-msg)")),3,end=-3)

#url 합치기

con_url2<-paste0("https://gall.dcinside.com/",con_url)

#조회수 뽑기

hit_index<-which(str_detect(b,"gall_count"))[-1]
hit<-as.numeric(str_sub(str_extract(b[hit_index], ("(?<=gall_count).*(?=</td>)")),3))

#추천수 뽑기

hit_index<-which(str_detect(b,"gall_recommend"))[-1]
rec<-as.numeric(str_sub(str_extract(b[hit_index], ("(?<=gall_recommend).*(?=</td>)")),3))


#댓글 뽑기

com_index<-which(str_detect(b,"reply_num"))
com<-as.numeric(str_sub(str_extract(b[com_index], ("(?<=reply_num).*(?=</span>)")),113, end=-2))

#한군데로 묶기

cbind(title, con_url2, com, hit, rec)



## 여러페이지 크롤링하기 ##
## 10페이지만 크롤링
dc_data<-NULL

for(i in 1:10){
url<-paste0('https://gall.dcinside.com/board/lists/?id=stock_new2&page=',i)

b<-readLines(url, encoding="UTF-8")

library(stringr)

# 게시글 제목, url 뽑기

index<-which(str_detect(b, "gall_tit ub-word"))[-1]

b2<-b[index+1]

title<-str_trim(str_extract(b2, ("(?<=</em>).*(?=</a>)")))

con_url<-str_sub(str_extract(b2, ("(?<=a  href=).*(?=view-msg)")),3,end=-3)

#url 합치기

con_url2<-paste0("https://gall.dcinside.com/",con_url)

#조회수 뽑기

hit_index<-which(str_detect(b,"gall_count"))[-1]
hit<-as.numeric(str_sub(str_extract(b[hit_index], ("(?<=gall_count).*(?=</td>)")),3))

#추천수 뽑기

hit_index<-which(str_detect(b,"gall_recommend"))[-1]
rec<-as.numeric(str_sub(str_extract(b[hit_index], ("(?<=gall_recommend).*(?=</td>)")),3))


#댓글 뽑기

com_index<-which(str_detect(b,"reply_num"))
com<-as.numeric(str_sub(str_extract(b[com_index], ("(?<=reply_num).*(?=</span>)")),113, end=-2))

#한군데로 묶기

data<-cbind(title, con_url2, com, hit, rec)

dc_data<-rbind(dc_data, data)
cat("\n",i)
}


## 결측치 열 제거

dc_data<-na.omit(dc_data)


## 데이터 확인하기

View(dc_data)
head(dc_data)
dim(dc_data)

setwd()

write.csv(dc_data, "dc_data_societypolitics_1.csv", row.names = F)





