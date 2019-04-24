function batch_n
%BATCH_N �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
tic
save4d23d_pre;
upsidedown;
save_3d24d;

RatPath             = 'F:\20180717_wangfei\converted_resting';
DirRat              = dir(RatPath);

for i = 3:length(DirRat)
   RatName          = DirRat(i).name;
   ImagePath        = [RatPath filesep RatName];
   ImagePathn       = strcat(ImagePath,'\*.img');
   DirImage         = dir(ImagePathn);
   ImageCol         = [];
   for j = 1:length(DirImage)
       ImageName    = DirImage(j).name;
           if(strcmp(ImageName(end-3:end), '.img')==1)
              ImgWholePath      = [ImagePath filesep ImageName]; 
              delete(ImgWholePath);
              HdrWholePath  = strcat(ImagePath,'\',ImageName(1:(end-3)),'hdr');
              delete(HdrWholePath);
           end
   end
end
toc
end

