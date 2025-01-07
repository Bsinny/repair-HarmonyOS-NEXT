export interface ResponseData<T> {
  code: number;
  msg: string;
  data: T | null;
}

export interface PageData<T> {
  pageNum: number;
  pageSize: number;
  total: number;
  rows: T[];
}

export interface UploadImages {
  fileList : string []
  previewImageList : string []
}