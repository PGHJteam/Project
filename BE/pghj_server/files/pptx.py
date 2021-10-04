from pptx import Presentation
from pptx.util import Inches, Pt

from pghj_server.settings import TEMPLATE_DIR


# Add slides
def add_slides(prs, items):
    # Get the total number of slides to add
    total_pages = items[len(items)-1]['page'] 

    # Add each slide
    for cur_page in (1, total_pages):
        slide_layout = prs.slide_layouts[6]        # Create slide_layout (6: BLANK)
        slide = prs.slides.add_slide(slide_layout) # Add a slide
        shapes = slide.shapes

        while items != []:
            item = items[0]    

            # Check the page
            page = item['page'] 
            if page > cur_page: # If next page, break
                break

            text = item['text']
            left = Inches(item['coordinate']['left'])
            top = Inches(item['coordinate']['top'])
            width = Inches(item['size']['width'])
            height = Inches(item['size']['height'])
            font_type = item['font']['type']
            font_size = item['font']['size']            
            
            text_box = shapes.add_textbox(left, top, width, height) # Create text box
            text_frame = text_box.text_frame                        # Get text frame from the text box
            p = text_frame.add_paragraph()                          # Add paragraph into text frame
            p.text = text                                           # Write text

            if font_type == "bold": 
                p.font.bold = True

            if font_type == "italic": 
                p.font.italic = True

            p.font_size = Pt(font_size)      

            items.pop(0)
    return prs


# Make presentation
def create_pptx(data, dir, upload_id):  
    template_id = data['template_id'] # Template Design ID
    items = data['items']             # Data       

    # Create Presentation
    if template_id == "template00": # If user do not choose any template, open new presentation
        prs = Presentation()
    else:                           # Else, open the presentation with certain template
        prs = Presentation(TEMPLATE_DIR + str(template_id) + '.pptx')
    
    # Add slides
    prs = add_slides(prs, items)

    # Save pptx
    pptx_path = dir + 'upload_id' + '.pptx'
    prs.save(pptx_path)

    return pptx_path
