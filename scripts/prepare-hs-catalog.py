#!/usr/bin/env python3
"""Extract UN Comtrade H6 XLSX and optionally translate descriptions offline.

Requires only the Python standard library for extraction. Translation mode also
requires sentencepiece and ctranslate2 plus an unpacked Argos en→fa model.
"""
import argparse, csv, re
from pathlib import Path
from zipfile import ZipFile
from xml.etree import ElementTree as ET

NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"

def read_xlsx(path):
    with ZipFile(path) as archive:
        shared=[]
        root=ET.fromstring(archive.read("xl/sharedStrings.xml"))
        for item in root.iter(f"{{{NS}}}si"):
            shared.append("".join(node.text or "" for node in item.iter(f"{{{NS}}}t")))
        sheet=ET.fromstring(archive.read("xl/worksheets/sheet1.xml"))
        rows=[]
        for row in sheet.iter(f"{{{NS}}}row"):
            values=[]
            for cell in row.findall(f"{{{NS}}}c"):
                value=cell.find(f"{{{NS}}}v")
                text="" if value is None else value.text or ""
                if cell.attrib.get("t")=="s" and text:
                    text=shared[int(text)]
                values.append(text)
            rows.append(values)
    header=rows[0]
    return [dict(zip(header,row)) for row in rows[1:] if row and row[0] != "TOTAL"]

def clean_text(code,text):
    return re.sub(rf"^{re.escape(code)}\s*-\s*", "", text).strip()

def refine_translation(english,persian):
    """Small HS-domain corrections; the result remains explicitly machine_draft."""
    if english.lower().endswith("; live"):
        persian=re.sub(r"؛\s*(زندگی(?:\s+می\s*کنند)?|زنده(?:\s+هستند)?)\s*$", "؛ زنده", persian)
    return persian.replace("هاله ها", "قاطرهای ماده")

def translator(model_dir):
    import ctranslate2, sentencepiece as spm
    model=Path(model_dir)
    processor=spm.SentencePieceProcessor(model_file=str(model/"sentencepiece.model"))
    engine=ctranslate2.Translator(str(model/"model"),device="cpu",compute_type="int8",inter_threads=2,intra_threads=4)
    def translate_many(texts):
        tokens=[processor.encode(text,out_type=str) for text in texts]
        results=engine.translate_batch(tokens,beam_size=1,max_batch_size=128,batch_type="examples",replace_unknowns=True)
        return [processor.decode(result.hypotheses[0]).strip() for result in results]
    return translate_many

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("xlsx")
    parser.add_argument("output")
    parser.add_argument("--model-dir")
    args=parser.parse_args()
    rows=read_xlsx(args.xlsx)
    translate=translator(args.model_dir) if args.model_dir else None
    descriptions=[clean_text(row["id"],row["text"]) for row in rows]
    translations=[]
    for start in range(0,len(rows),128):
        batch=descriptions[start:start+128]
        translated=translate(batch) if translate else batch
        translations.extend(refine_translation(en,fa) for en,fa in zip(batch,translated))
        print(f"prepared {min(start+128,len(rows))}/{len(rows)}",flush=True)
    with open(args.output,"w",encoding="utf-8",newline="") as handle:
        writer=csv.writer(handle,delimiter="\t",quoting=csv.QUOTE_MINIMAL)
        writer.writerow(["code","name_en","name_fa","parent","is_leaf","level","standard_unit_abbr"])
        for row,en,fa in zip(rows,descriptions,translations):
            writer.writerow([row["id"],en,fa,row["parent"],row["isLeaf"],row["aggrlevel"],row["standardUnitAbbr"]])

if __name__=="__main__": main()
