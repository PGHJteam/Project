import torch
import pickle
from transformers import ViTFeatureExtractor, VisionEncoderDecoderModel
from contextlib import contextmanager
from transformers.feature_extraction_utils import FeatureExtractionMixin
from torch import nn


##processor 만들기
class TrOCRProcessor:
    def __init__(self, feature_extractor, tokenizer):
        if not isinstance(feature_extractor, FeatureExtractionMixin):
            raise ValueError(
                f"`feature_extractor` has to be of type {FeatureExtractionMixin.__class__}, but is {type(feature_extractor)}"
            )

        self.feature_extractor = feature_extractor
        self.tokenizer = tokenizer

        self.current_processor = self.feature_extractor

    def __call__(self, *args, **kwargs):
        return self.current_processor(*args, **kwargs)

    def batch_decode(self, *args, **kwargs):
        return self.tokenizer.batch_decode(*args, **kwargs)

    def decode(self, *args, **kwargs):
        return self.tokenizer.decode(*args, **kwargs)

    @contextmanager
    def as_target_processor(self):
        self.current_processor = self.tokenizer
        yield
        self.current_processor = self.feature_extractor
with open('kobert_processor.pkl','rb') as f:
    kobert = pickle.load(f)
kor_processor = TrOCRProcessor(kobert, ViTFeatureExtractor(size=384))
with open('kor_processor.pkl','wb') as f:
    pickle.dump(kor_processor,f)
#모델불러오기
with open('eng_htr_model.pkl','rb') as f:
    model = pickle.load(f)
# model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")
#train모드로 바꾸고 freeze하기
new_output_projection = nn.Linear(1024,8002);torch.nn.init.xavier_uniform_(new_output_projection.weight)
model.decoder.output_projection = new_output_projection
new_embed = nn.Embedding(8002,1024,padding_idx=1); nn.init.uniform_(new_embed.weight, -1.0, 1.0)
model.decoder.model.decoder.embed_tokens = new_embed
# config 수정
model.config.decoder_start_token_id = kor_processor.tokenizer.cls_token_id
model.config.pad_token_id = kor_processor.tokenizer.pad_token_id
model.config.vocab_size = model.config.decoder.vocab_size
model.load_state_dict(torch.load('./kotrocr.pth', map_location='cpu'))
model.eval()
model.decoder.eval()
model.encoder.eval()

for param in model.decoder.parameters():
    param.requires_grad = False
for param in model.parameters():
    param.requires_grad = False
for param in model.encoder.parameters():
    param.requires_grad = False
kor_model = model

with open('kor_htr_model.pkl','wb') as f:
    pickle.dump(kor_model,f)


