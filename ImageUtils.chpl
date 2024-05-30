module ImageUtils {
  public use Image;

  /* Controls whether an image is printed */
  config const image = false;
  /* A factor to scale the image by */
  config const imageScale = 1;
  /* The framerate of the video */
  config const framerate = 10;
  /* The height of the image, only applicable for 1D input data */
  config const imageHeight = 256;

  private proc checkDimsHelper(width: int, height: int) {
    if height < 64 then
      halt("Image of minimum height 64 is required, got ", height);
    if width > 4000 then
      halt("Image of maximum width 4000 is required, got ", width);
  }
  private proc checkDims(data: [?d]) where d.isRectangular() && d.rank == 2 do
    checkDimsHelper(data.dim(1).size, data.dim(0).size);
  private proc checkDims(data: [?d]) where d.isRectangular() && d.rank == 1 do
    checkDimsHelper(d.size, imageHeight);


  private proc processFrameData(data: [?d]) where d.isRectangular() && d.rank == 1 {
    // make the 1d data into 2d data of a specific height
    var data2d: [0..#imageHeight, d.lowBound..d.highBound] data.eltType;
    for i in 0..#imageHeight do
      data2d[i,..] = data;

    return processFrameData(data2d);
  }
  private proc processFrameData(data: [?d]) where d.isRectangular() && d.rank == 2 {
    // create a white border around the image and turn raw data into pixels
    var image: [data.domain.expand(1)] int = 0xFFFFFF;
    image[data.domain] = interpolateColor(data, 0x000000, 0x0000FF);

    return scale(image, imageScale);
  }

  proc writeImage(u: []) throws {
    if !image then return;

    checkDims(u);

    on Locales[0] {
      @functionStatic
      ref pipe = try! new mediaPipe("heat.mp4", imageType.bmp, framerate);

      pipe.writeFrame(processFrameData(u));
    }
  }
}
