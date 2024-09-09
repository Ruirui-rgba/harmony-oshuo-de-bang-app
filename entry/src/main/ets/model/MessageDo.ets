export class MessageModel{
  counts:number=0
  items:Array<MessageInModel>=[]
  page:number=1
  pageSize:number=1
  pages:number=1

  constructor(counts: number, items: Array<MessageInModel>, page: number, pageSize: number, pages: number) {
    this.counts = counts
    this.items = items
    this.page = page
    this.pageSize = pageSize
    this.pages = pages
  }

}


export class MessageInModel{
  bussinessType:number=1
  content:string=''
  contentType:number=300
  createUser:number=1
  created:string=''
  id:number=1
  isRead:number=0
  readTime:string=''
  relevantId:number=1
  title:string=''
  updateUser:number=1
  updated:string=''
  userId:number=0

  constructor(bussinessType: number, content: string, contentType: number, createUser: number, created: string,
    id: number, isRead: number, readTime: string, relevantId: number, title: string, updateUser: number,
    updated: string, userId: number) {
    this.bussinessType = bussinessType
    this.content = content
    this.contentType = contentType
    this.createUser = createUser
    this.created = created
    this.id = id
    this.isRead = isRead
    this.readTime = readTime
    this.relevantId = relevantId
    this.title = title
    this.updateUser = updateUser
    this.updated = updated
    this.userId = userId
  }

}