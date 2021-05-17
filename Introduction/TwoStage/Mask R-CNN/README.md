<h1 align="center"> Mask R-CNN </h1>

<h2 align="center"> Introduction </h2>

- 作者提出了一個簡單，靈活且通用的 object instance segmentation 架構。作者的方法有效地 detect 到圖像中的 objects，同時為每個 instance 生成高質量的 segmentation mask。該方法稱為 “Mask R-CNN”，它通過擴展 “Faster R-CNN” 添加了一個分支（FCN）來 predict object mask 與現有的 bounding box recognition 和 classification 分支平行。Mask R-CNN 易於訓練和僅對 “Faster R-CNN” 添加了很小的開銷，並且以 5 fps 的速度運行。此外，Mask R-CNN 易於推廣到其他任務，例如：estimate human poses（估算人體姿勢）。作者在 COCO 数据集的三個挑战任務中都有明顯的最佳結果，三個任務分別為 instance segmentation（實例分割），bounding-box object detection （邊界框物體檢測）和 person keypoint detection（人員關鍵點檢測）。

---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Figure1.jpg" width="100%" height="100%">
(Figure 1) Semantic segmentation vs Instance segmentation

- Instance Segmentation具有挑戰性，因為它需要正確檢測圖像中的所有物體，同時還要精確分割每個 instance。因此，結合了
    - Object Detection: Figure 1中的b目標是使用 object detection 對單個物體進行 classify 和 localize。
    - Semantic Segmentation: Figure 1中的 c目標是將每個像素分類為固定的類別集而無需區分 object instances。

- 觀察 Figure 1 中的 c 和 d 圖，c 圖是對 a 圖進行 Semantic segmentation（語義分割）的結果，d 圖是對 a 圖進行 Instance segmentation（實例分割）的結果。兩者最大的區別就是圖中的 "cube對象"，在語義分割中給了它們相同的顏色，而在實例分割中卻給了不同的顏色。即實例分割需要在語義分割的基礎上對同類物體進行更精細的分割。

---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Figure2.gif" width="100%" height="100%">
(Figure 2) The Mask R-CNN framework for instance segmentation

- Mask R-CNN 通過添加一個分支（FCN）來預測每個 Region of Interest（RoI，關注區域）上的 segmentation masks，從而與 Faster R-CNN 進行了擴展，該分支與現有的用於 classification和 bounding box regression的分支平行（Figure 2）。 Mask 分支是應用於每個 RoI 的小 FCN，以 pixel-to-pixel 的方式預測 segmentation mask。有了 Faster R-CNN 框架，Mask R-CNN 易於 implement 和 train，從而促進了多種靈活的體系結構設計。另外，mask 分支僅增加了少量的計算開銷，從而實現了快速的系統和快速的實驗。

---
- **Good Speed** 和 **Good Accuracy**：為了實現這個目的，作者選用了經典的目標檢測演算法 Faster R-CNN 和經典的語義分割演算法 FCN。 Faster R-CNN 可以既快又準的完成目標檢測的功能，FCN 可以精準的完成語義分割的功能，這兩個演算法都是對應領域中的經典之作。 Mask R-CNN 比 Faster R-CNN 複雜，但是最終仍然可以達到 5fps 的速度，這和原始的 Faster R-CNN 的速度相當。由於發現了 RoIPooling 中所存在的像素偏差問題，提出了對應的 RoIAlign 策略，加上 FCN 精準的像素 MASK，使得其可以獲得高準確率。

- **Intuitive**：整個 Mask R-CNN 演算法的思路很簡單，就是在原始 Faster R-CNN 演算法的基礎上面增加了 FCN 來產生對應的 mask 分支。即 Faster R-CNN + FCN，更細緻的是 RPN + RoIAlign + Faster R-CNN + FCN。

- **Easy to use**：整個 Mask R-CNN 演算法非常的靈活，可以用來完成多種任務，包括目標分類、目標檢測、語義分割、實例分割、人體姿態識別等多個任務，這將其易於使用的特點展現的淋漓盡致。除此之外，我們可以更換不同的 backbone architecture 和 Head Architecture 來獲得不同性能的結果。
---

---
<h2 align="center"> Mask R-CNN：Inference </h2>

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Figure3.JPG" width="100%" height="100%">
（Figure 3）Inference

- Mask R-CNN 採用相同的 two-stage 過程，具有 Faster R-CNN 相同的第一階段為 Region Proposal Network（RPN，區域候選網絡）。在第二階段，並行預測 class 和 box offset，Mask R-CNN 還為每個 RoI 輸出一個 binary mask。該分支是通過FCN網絡架構（如Figure 3中的 small FCN）來實現的。以上這三個輸出分支（class，box 和 mask）相互之間都是平行關係。

---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Figure4.gif" width="100%" height="100%">
（Figure 4）Head Architecture

- Figure 4 的左圖是基於 Faster R-CNN 引入 mask 分支後的檢測部分。圖中的 RoI 指的就是 RoIAlign 操作，採用 7*7 大小的劃分得到 7*7*1024 維度的 feature map，然後再接 ResNet 中的 res5 結構，另外這裡對 res5 做了修改，使得這個結構不改變輸入 feature map 的寬高，res5 結構輸出 7*7*2048 維度的 feature map。基於該 feature map 有兩條分支，上面那條分支經過 Global Pooling 得到 1*1*2048 維度的輸出並作為 class 分支和 box 分支的輸入，下面那條分支接 Deconvolution layer （14*14*256） 和 Convolution layer （14*14*80）來得到 mask。

- Figure 4 的右圖是基於 FPN 演算法引入 mask 分支後的檢測部分。 FPN 中就將原來 Faster R-CNN 中的 RoIPool 移到 res5 後面，也就是 RoIPool layer 之後不再涉及一些特徵提取操作，這樣就減少了很多重複計算。圖中的 RoI 指的就是 RoIAlign 操作，上面一條分支得到維度為 7*7*256 的feature map（因為 FPN 算法是基於 5個融合特徵層分別做檢測，這裡僅以一個融合特徵層為例介紹，每個融合特徵層的輸出 channel 都是256，因此經過 RoIAlign 後得到的輸出 channel 還是 256），最後接兩個 1024 維度的全連接層就可以做為 class 和 box 分支的輸入。下面一條分支用 14*14 大小的劃分得到 14*14*256 的輸出，然後接數個 convolution （28*28*256） 和 deconvolution layer （28*28*80）得到 mask。

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Table1a.png" width="100%" height="100%">
（Table 1）Ablations

- 根據 Table 1 中的 a進行分析，結果表明 backbone 加了 FPN 演算法的架構呈現結果會比沒有加的架構來的好。可以看 ResNet-50-FPN 的 AP 比 ResNet-50-C4 的 AP 高了3.3個百分點，而 ResNet-101-FPN 的 AP 比 ResNet-101-C4 的 AP 高了2.7個百分點。
---

---
<h2 align="center"> Mask R-CNN：RoIAlign </h2>

- RoIPool 實際上是用於處理 instances的核心操作，如何執行 coarse spatial quantization以進行特徵提取的過程中最為明顯。為了解決不對齊問題，作者提出了一個簡單的 quantization-free layer，稱為RoIAlign，它忠實地保留了準確的空間位置。儘管看似很小的變化，RoIAlign 仍具有很大的影響：它將 mask 的精度提高了 10％ 至 50％，在更嚴格的定位指標下顯示出更大的收益。

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Figure5.JPG" width="100%" height="100%">
（Figure 5）RoIAlign vs RoIPool

- 在介紹 RoIAlign 之前，先大致回顧下 RoIPool 層的操作：RoIPool 的輸入是 RoI 的坐標和某一層的輸出特徵，不管是 RoIPool 還是 RoIAlign，目的都是提取輸出特徵圖上該 RoI 坐標所對應的特徵。 RPN 網絡得到的 RoI 坐標是針對輸入圖像大小的，所以首先需要將 RoI 坐標縮小到輸出特徵對應的大小，假設輸出特徵尺寸是輸入圖像的 1/16，那麼先將 RoI 坐標除以16並取整（第一次量化），然後將取整後的 RoI 劃分成 H*W 個 bin（論文中是7*7，有時候也用14*14），因為劃分過程得到的 bin 的坐標是浮點值，所以這裡還要將 bin 的坐標也做一個量化，具體而言對於左上角坐標採用向下取整，對於右下角坐標採用向上取整，最後採用 max pooling 操作處理每個 bin，也就是用每個 bin 中的最大值作為該 bin 的值，每個 bin 都通過這樣的方式得到值，最終輸出的 H*W 大小的 RoI 特徵。從這裡的介紹可以看出 RoIPool 有兩次量化操作，這兩步量化操作會引入誤差。

- 相比之下 RoIAlign 不再引入量化操作，對於 RPN 網絡得到的 RoI 坐標直接除以縮放倍數（例如16），這個過程不進行量化，因此得到的 RoI 坐標仍是浮點值，然後將 RoI 劃分成 H*W 個 bin，劃分得到的 bin 坐標也是浮點值，不進行量化，接著通過在每個 bin 中均勻取 4個點，這 4個點的值通過該 bin 所包含的點插值計算（線性內差）得到，最後對這 4個點求均值或最大值作為這個 bin 的值，通過這種方式計算每個bin的值後，最終輸出 H*W 大小的 RoI 特徵。可以看出 RoIAlign 整個過程沒有採用量化操作，因此大大減少了量化帶來的誤差。
---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Table1b.png" width="100%" height="100%">
（Table 1）Ablations

- 根據 Table 1 中的 c 是在 ResNet-50-C4 上進行的 RoIPool、RoIWarp 和 RoIAlign 的對比，可以看出 RoIAlign 的有效性。

- 由前面的分析，RoIAlign 會使得目標檢測的效果有很大的性能提升。根據 Table 1 中的 d，進行定量的分析，結果表明，RoIAlign 使得 mask 的 AP 值提升了 10.5個百分點，使得 box 的 AP 值提升了 9.5個百分點。
---

---
<h2 align="center"> Mask R-CNN：Training </h2>

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Figure6.JPG" width="100%" height="100%">
（Figure 6）Training

- 由於增加了 mask分支，每個 ROI 的 Loss 函數如下所示: L = L_\mathrm{cls} + L_{box} + L_{mask} 。其中 L_\mathrm{cls} 與 L_{box} 和 Faster R-CNN 中定義的相同。對於每一個 RoI，mask 分支有 $ Km^2 $ 維度的輸出，其對 K 個大小為 m*m 的 mask 進行編碼，每一個 mask 有 K 個類別。作者使用了 per-pixel sigmoid，並且將 L_{mask} 定義為 the average binary cross-entropy loss 。作者定義的 L_{mask} 允許網絡為每一個 class 生成一個 mask，而不用和其它 class 進行競爭，作者依賴於分類分支所預測的類別標籤來選擇輸出的 mask。

---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Table1c.png" width="100%" height="100%">
（Table 1）Ablations

- 根據 Table 1 中的 b 分析，Mask R-CNN 利用兩個分支將分類和 mask 生成分解開來，然後利用 Binary Loss （sigmoid）代替 Multinomial Loss（softmax），使得不同類別的 mask 之間消除了競爭。依賴於分類分支所預測的類別標籤來選擇輸出對應的 mask。使得 mask 分支不需要進行重新的分類工作，使得性能得到了提升（5.5個百分點）。

- 根據Table 1 中的e 分析，MLP 即利用FC 來生成對應的mask，而FCN 利用Conv 來生成對應的mask，僅僅從參數量上來講，後者比前者少了很多，這樣不僅會節約大量的內存空間，同時會加速整個訓練過程。除此之外，由於 MLP 獲得的特徵比較抽象，使得最終的 mask 中丟失了一部分有用信息，而 FCN 有空間結構的特徵，可以把空間結構的特徵保留下來。 FCN 使得 mask AP 值提升了 2.1個百分點。
---
<h2 align="center"> Experiments </h2>

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Table2.gif" width="100%" height="100%">
（Table 2）Instance Segmentation Mask AP on COCO test-dev

- 在 Table 2 的實例分割中，作者將 Mask R-CNN 與最新方法進行了比較。作者模型的所有實例化均優於先前最新模型的基線變體。 其中包括 MNC 和 FCIS，分別是 2015年和 2016年 COCO 細分挑戰賽的獲勝者。 無需費吹灰之力，帶有 ResNet-101-FPN backbone 的 Mask R-CNN 的性能優於 FCIS +++。

---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Table3.gif" width="100%" height="100%">
（Table 3）The result of the Object Detection

- 觀察 Table 3，可以發現使用了 RoIAlign 操作的 Faster R-CNN 演算法（APbb = 37.3）性能比 Mask R-CNN （APbb = 38.2）低了 0.9個百分點。帶有 ResNet-101-FPN backbone 的 Mask R-CNN 比帶有 ResNet-101-FPN backbone 的 Faster R-CNN 高出了 2個百分點。
---
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/TwoStage/Mask R-CNN/img/Table4.gif" width="100%" height="100%">
（Table 4）The result of the Human Pose Estimation

- 作者評估 person keypoint 的 AP（APkp），並使用 ResNet-50-FPN backbone進行實驗。 Table 4顯示了，Mask R-CNN的結果（62.7 APkp）比使用多階段處理管道的COCO 2016關鍵點檢測獲勝者 CMU-Pose+++ 高0.9個百分點。 作者的方法相當簡單和快捷。
---

---
<h2 align="center"> Conclusion </h2>

- 作者提供了一個簡單有效的 instance segmentation 架構，該架構在 bounding box detection 上也顯示出良好的效果，並且可以擴展到 human pose estimation。 作者希望此架構的 simplicity和 generality將有助於將來對這些以及其他 instance-level的 visual recognition任務進行研究。

- Mask R-CNN 論文的主要貢獻包括以下幾點：
    - 分析了 RoIPool 的不足，提出了 RoIAlign，提升了檢測和實例分割的效果
    - 將實例分割分解為分類和 mask 生成兩個分支，依賴於分類分支所預測的類別標籤來選擇輸出對應的 mask。同時利用 Binary Loss 代替 Multinomial Loss，消除了不同類別的 mask 之間的競爭，生成了準確的二值 mask
    - 並行進行分類和 mask 生成任務，對模型進行了加速。


---

---
<h2 align="center"> Paper </h2>

- [2017 IEEE International Conference on Computer Vision (ICCV)](https://ieeexplore.ieee.org/document/8237584)
- [IEEE Transactions on Pattern Analysis and Machine Intelligence ( Volume: 42, Issue: 2, Feb. 1 2020)](https://ieeexplore.ieee.org/document/8372616)

