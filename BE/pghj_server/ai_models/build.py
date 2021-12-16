from transformers import TrOCRProcessor
from kobert_transformers import get_tokenizer

import torch
import pickle
from transformers import ViTFeatureExtractor, VisionEncoderDecoderModel
from contextlib import contextmanager
from transformers.feature_extraction_utils import FeatureExtractionMixin
from torch import nn
import pickle

eng_processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-handwritten")
eng_htr_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")
eng_ocr_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-printed")

kobert = get_tokenizer()
with open('kobert_processor.pkl','wb') as f:
    pickle.dump(kobert,f)
with open('eng_processor.pkl','wb') as f:
  pickle.dump(eng_processor,f)
with open('eng_htr_model.pkl','wb') as f:
  pickle.dump(eng_htr_model,f)
with open('eng_ocr_model.pkl','wb') as f:
  pickle.dump(eng_ocr_model,f)



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
kor_processor = TrOCRProcessor(ViTFeatureExtractor(size=384),kobert)


with open('kor_processor.pkl','wb') as f:
    pickle.dump(kor_processor,f)

model = eng_htr_model
#train모드로 바꾸고 freeze하기
new_output_projection = nn.Linear(1024,8002);torch.nn.init.xavier_uniform_(new_output_projection.weight)
model.decoder.output_projection = new_output_projection
new_embed = nn.Embedding(8002,1024,padding_idx=1); nn.init.uniform_(new_embed.weight, -1.0, 1.0)
model.decoder.model.decoder.embed_tokens = new_embed
# config 수정
model.config.decoder_start_token_id = kor_processor.tokenizer.cls_token_id
model.config.pad_token_id = kor_processor.tokenizer.pad_token_id
model.config.vocab_size = model.config.decoder.vocab_size
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


