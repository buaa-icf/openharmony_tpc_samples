/**
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { describe, it, expect } from '@ohos/hypium'
import {
    escapeUTF8,
    encode,
    encodeXML,
    encodeHTML,
    encodeNonAsciiHTML,
    decodeXML,
    decodeHTML,
    decodeHTMLStrict,
    decode,
    decodeHTMLAttribute,
    DecodingMode,
    encodeHTML5,
    decodeStrict,
    escapeAttribute,
    escapeText,
    EncodingMode,
    EntityLevel,
} from "entities";
import { EntityDecoder, EntityErrorProducer, htmlDecodeTree } from 'entities/lib/decode.js';

export default function abilityTest() {
    describe('ActsAbilityTest', () => {

        class B {
            input: string = ""
            output: string = ""
        }

        const testcases1: B[] = [
            {
                input: "&amp;amp;", output: "&amp;"
            },
            {
                input: "&amp;#38;", output: "&#38;"
            },
            {
                input: "&amp;#x26;", output: "&#x26;"
            },
            {
                input: "&amp;#X26;", output: "&#X26;"
            },
            {
                input: "&#38;#38;", output: "&#38;"
            },
            {
                input: "&#x26;#38;", output: "&#38;"
            },
            {
                input: "&#X26;#38;", output: "&#38;"
            },
            {
                input: "&#x3a;", output: ":"
            },
            {
                input: "&#x3A;", output: ":"
            },
            {
                input: "&#X3a;", output: ":"
            },
            {
                input: "&#X3A;", output: ":"
            },
            {
                input: "&#", output: "&#"
            },
            {
                input: "&>", output: "&>"
            },
            {
                input: "id=770&#anchor", output: "id=770&#anchor"
            },
        ];

        for (let i = 0; i < testcases1.length; i++) {
            let input = testcases1[i].input
            let output = testcases1[i].output
            it("should_XML_decode", 0, () => {
                expect(decodeXML(input)).assertEqual(output);
            });

            it("should_HTML_decode", 0, () => {
                expect(decodeHTML(input)).assertEqual(output);
            });
        }

        it("should_HTML_decode_partial_legacy_entity", 0, () => {
            expect(decodeHTMLStrict("&timesbar")).assertEqual("&timesbar");
            expect(decodeHTML("&timesbar")).assertEqual("×bar");
        });

        it("should_HTML_decode_legacy_entities_according_to_spec", 0, () => {
            expect(decodeHTML("?&image_uri=1&ℑ=2&image=3")).assertEqual(
                "?&image_uri=1&ℑ=2&image=3",
            )
        })

        it("should_back_out_of_legacy_entities", 0, () => {
            expect(decodeHTML("&ampa")).assertEqual("&a");
        })

        it("should_not_parse_numeric_entities_in_strict_mode", 0, () => {
            expect(decodeHTMLStrict("&#55")).assertEqual("&#55");
        })

        it("should_parse_followed_by", 0, () => {
            expect(decodeHTML("&nbsp<")).assertEqual("\u00a0<");
        })

        it("should_decode_trailing_legacy_entities", 0, () => {
            expect(decodeHTML("&timesbar;&timesbar")).assertEqual("⨱×bar");
        });


        it("should_decode_multi_byte_entities", 0, () => {
            expect(decodeHTML("&NotGreaterFullEqual;")).assertEqual("≧̸");
        });

        it("should_not_decode_legacy_entities_followed_by_text_in_attribute_mode", 0, () => {
            expect(
                decodeHTML("&not", DecodingMode.Attribute),
            ).assertEqual("¬");

            expect(
                decodeHTML("&noti", DecodingMode.Attribute),
            ).assertEqual("&noti");

            expect(
                decodeHTML("&not=", DecodingMode.Attribute),
            ).assertEqual("&not=");

            expect(decodeHTMLAttribute("&notp")).assertEqual("&notp");
            expect(decodeHTMLAttribute("&notP")).assertEqual("&notP");
            expect(decodeHTMLAttribute("&not3")).assertEqual("&not3");
        });


        it("should_decode_decimal_entities", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            expect(decoder.write("&#5", 1)).assertEqual(-1);
            expect(decoder.write("8;", 0)).assertEqual(5);
        });

        it("should_decode_hex_entities", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            expect(decoder.write("&#x3a;", 1)).assertEqual(6);
        });

        it("should_decode_named_entities", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            expect(decoder.write("&amp;", 1)).assertEqual(5);
        });

        it("should_decode_legacy_entities", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            decoder.startEntity(DecodingMode.Legacy);
            expect(decoder.write("&amp", 1)).assertEqual(-1);
            expect(decoder.end()).assertEqual(4);
        });

        it("should_decode_named_entity_written_character_by_character", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            for (const c of "amp") {
                expect(decoder.write(c, 0)).assertEqual(-1);
            }
            expect(decoder.write(";", 0)).assertEqual(5);
        });

        it("should_decode_numeric_entity_written_character_by_character", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            for (const c of "#x3a") {
                expect(decoder.write(c, 0)).assertEqual(-1);
            }
            expect(decoder.write(";", 0)).assertEqual(6);
        });

        it("should_decode_hex_entities_across_several_chunks", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            for (const chunk of ["#x", "cf", "ff", "d"]) {
                expect(decoder.write(chunk, 0)).assertEqual(-1);
            }
            expect(decoder.write(";", 0)).assertEqual(9);
        });

        it("should_not_fail_if_nothing_is_written", 0, () => {
            const decoder = new EntityDecoder(htmlDecodeTree, cb);
            expect(decoder.end()).assertEqual(0);
        });

        it("should_produce_an_error_for_a_named_entity_without_a_semicolon", 0, () => {
            const errorHandlers: EntityErrorProducer = {
                missingSemicolonAfterCharacterReference() {
                    console.error("Missing semicolon after character reference.");
                },
                absenceOfDigitsInNumericCharacterReference(consumedCharacters: number) {
                    console.error(`Absence of digits in numeric character reference after consuming ${consumedCharacters} characters.`);
                },
                validateNumericCharacterReference(code: number) {
                    console.error(`Invalid numeric character reference: ${code}.`);
                }
            };

            const decoder = new EntityDecoder(
                htmlDecodeTree,
                cb,
                errorHandlers,
            );
            decoder.startEntity(DecodingMode.Legacy);
            expect(decoder.write("&amp;", 1)).assertEqual(5);
            decoder.startEntity(DecodingMode.Legacy);
            expect(decoder.write("&amp", 1)).assertEqual(-1);
            expect(decoder.end()).assertEqual(4);
        });

        it("should_produce_an_error_for_a_numeric_entity_without_a_semicolon", 0, () => {
            const errorHandlers: EntityErrorProducer = {
                missingSemicolonAfterCharacterReference() {
                    console.error("Missing semicolon after character reference.");
                },
                absenceOfDigitsInNumericCharacterReference(consumedCharacters: number) {
                    console.error(`Absence of digits in numeric character reference after consuming ${consumedCharacters} characters.`);
                },
                validateNumericCharacterReference(code: number) {
                    console.error(`Invalid numeric character reference: ${code}.`);
                }
            };
            const decoder = new EntityDecoder(
                htmlDecodeTree,
                cb,
                errorHandlers,
            );

            decoder.startEntity(DecodingMode.Legacy);
            expect(decoder.write("&#x3a", 1)).assertEqual(-1);
            expect(decoder.end()).assertEqual(5);
        });

        it("should_produce_an_error_for_numeric_entities_without_digits", 0, () => {
            const errorHandlers: EntityErrorProducer = {
                missingSemicolonAfterCharacterReference() {
                    console.error("Missing semicolon after character reference.");
                },
                absenceOfDigitsInNumericCharacterReference(consumedCharacters: number) {
                    console.error(`Absence of digits in numeric character reference after consuming ${consumedCharacters} characters.`);
                },
                validateNumericCharacterReference(code: number) {
                    console.error(`Invalid numeric character reference: ${code}.`);
                }
            };
            const decoder = new EntityDecoder(
                htmlDecodeTree,
                cb,
                errorHandlers,
            );

            decoder.startEntity(DecodingMode.Legacy);
            expect(decoder.write("&#", 1)).assertEqual(-1);
            expect(decoder.end()).assertEqual(0);
        });

        it("should_produce_an_error_for_hex_entities_without_digits", 0, () => {
            const errorHandlers: EntityErrorProducer = {
                missingSemicolonAfterCharacterReference() {
                    console.error("Missing semicolon after character reference.");
                },
                absenceOfDigitsInNumericCharacterReference(consumedCharacters: number) {
                    console.error(`Absence of digits in numeric character reference after consuming ${consumedCharacters} characters.`);
                },
                validateNumericCharacterReference(code: number) {
                    console.error(`Invalid numeric character reference: ${code}.`);
                }
            };
            const decoder = new EntityDecoder(
                htmlDecodeTree,
                cb,
                errorHandlers,
            );

            decoder.startEntity(DecodingMode.Legacy);
            expect(decoder.write("&#x", 1)).assertEqual(-1);
            expect(decoder.end()).assertEqual(0);
        });

        class A {
            input: string = ""
            xml: string = ""
            html: string = ""
        }

        const testcases: A[] = [
            {
                input: "asdf & ÿ ü '",
                xml: "asdf &amp; &#xff; &#xfc; &apos;",
                html: "asdf &amp; &yuml; &uuml; &apos;",
            },
            {
                input: "&#38;",
                xml: "&amp;#38;",
                html: "&amp;&num;38&semi;",
            },
        ];


        for (let i = 0; i < testcases.length; i++) {
            let input = testcases[i].input
            let xml = testcases[i].xml
            let html = testcases[i].html
            const encodedXML = encodeXML(input);
            it(`should_XML_encode_input`, 0, () => {
                expect(encodedXML).assertEqual(xml);
            })
            it(`should_default_to_XML_encode_input`, 0, () => {
                expect(encode(input)).assertEqual(xml);
            })
            it(`should_XML_decode_encodedXML`, 0, () => {
                expect(decodeXML(encodedXML)).assertEqual(input);
            })
            it(`should_default_to_XML_encode ${encodedXML}`, 0, () => {
                expect(decode(encodedXML)).assertEqual(input);
            })
            it(`should_default_strict_to_XML_encode ${encodedXML}`, 0, () => {
                expect(decodeStrict(encodedXML)).assertEqual(input);
            })

            const encodedHTML5 = encodeHTML5(input);
            it(`should_HTML5_encode_input`, 0, () => {
                expect(encodedHTML5).assertEqual(html);
            })
            it(`should_HTML5_decode_encodedHTML5`, 0, () => {
                expect(decodeHTML(encodedHTML5)).assertEqual(input);
            })
            it("should_encode_emojis", 0, () => {
                expect(encodeHTML5("😄🍾🥳💥😇")).assertEqual(
                    "&#x1f604;&#x1f37e;&#x1f973;&#x1f4a5;&#x1f607;",
                );
            })
        }

        it("should_encode_data_URIs_issu16", 0, () => {
            const data =
                "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAALAAABAAEAAAIBRAA7";
            expect(decode(encode(data))).assertEqual(data);
        });

        it("should_HTML_encode_all_ASCII_characters", 0, () => {
            for (let i = 0; i < 128; i++) {
                const char = String.fromCharCode(i);
                const encoded = encodeHTML(char);
                const decoded = decodeHTML(encoded);
                expect(decoded).assertEqual(char);
            }
        });

        it("should_encode_trailing_parts_of_entities", 0, () => {
            expect(encodeHTML("\ud835")).assertEqual("&#xd835;");
        })

        it("should_encode_surrogate_pair_with_first_surrogate_equivalent_of_ntity_without_corresponding_entity", 0, () => {
            expect(encodeHTML("\u{1d4a4}")).assertEqual("&#x1d4a4;");
        })

        it("should_encode_all_non_ASCII_characters", 0, () => {
            expect(encodeNonAsciiHTML("<test> #123! übermaßen")).assertEqual(
                "&lt;test&gt; #123! &uuml;berma&szlig;en",
            );
        })

        it("should_encode_emojis", 0, () => {
            expect(encodeNonAsciiHTML("😄🍾🥳💥😇")).assertEqual(
                "&#x1f604;&#x1f37e;&#x1f973;&#x1f4a5;&#x1f607;",
            );
        })

        it("should_encode_chars_above_surrogates", 0, () => {
            expect(encodeNonAsciiHTML("♒️♓️♈️♉️♊️♋️♌️♍️♎️♏️♐️♑️")).assertEqual(
                "&#x2652;&#xfe0f;&#x2653;&#xfe0f;&#x2648;&#xfe0f;&#x2649;&#xfe0f;&#x264a;&#xfe0f;&#x264b;&#xfe0f;&#x264c;&#xfe0f;&#x264d;&#xfe0f;&#x264e;&#xfe0f;&#x264f;&#xfe0f;&#x2650;&#xfe0f;&#x2651;&#xfe0f;",
            );
        })

        it("should_escape_HTML_attribute_values", 0, () => {
            expect(escapeAttribute('<a " attr > & value \u00a0!')).assertEqual("<a &quot; attr > &amp; value &nbsp;!")
        })

        it("should_escape_HTML_text", 0, () => {
            expect(escapeText('<a " text > & value \u00a0!')).assertEqual('&lt;a " text &gt; &amp; value &nbsp;!');
        })

        it("should_decode",0, () => {
            const obj: ESObject = JSON.parse('{"Aacute":"Á","aacute":"á","Acirc":"Â","acirc":"â","acute":"´","AElig":"Æ","aelig":"æ","Agrave":"À","agrave":"à","amp":"&","AMP":"&","Aring":"Å","aring":"å","Atilde":"Ã","atilde":"ã","Auml":"Ä","auml":"ä"}')
            let legacyMap: Map<string, string> = new Map(Object.entries(obj));
            for (const e of Object.keys(legacyMap)) {
                console.info("test----"+e)
                expect(decodeHTML(`&${e}`)).assertEqual(legacyMap[e]);
                expect(
                    decodeStrict(`&${e}`, {
                        level: EntityLevel.HTML,
                        mode: DecodingMode.Legacy,
                    }),
                ).assertEqual(legacyMap[e]);
            }
        });

        const levels = ["xml", "entities"];
        const obj: ESObject = JSON.parse('{"amp":"&","apos":"\'","gt":">","lt":"<"}')
        const obj1: ESObject = JSON.parse('{"Aacute":"Á","aacute":"á","Abreve":"Ă","abreve":"ă","ac":"∾","acd":"∿","acE":"∾̳","Acirc":"Â","acirc":"â","acute":"´","Acy":"А","acy":"а","AElig":"Æ","aelig":"æ","af":"⁡","Afr":"𝔄","afr":"𝔞","Agrave":"À","agrave":"à","alefsym":"ℵ","aleph":"ℵ","Alpha":"Α","alpha":"α","Amacr":"Ā","amacr":"ā","amalg":"⨿","amp":"&","AMP":"&","andand":"⩕","And":"⩓","and":"∧","andd":"⩜","andslope":"⩘","andv":"⩚","ang":"∠","ange":"⦤","angle":"∠","angmsdaa":"⦨","angmsdab":"⦩","angmsdac":"⦪","angmsdad":"⦫","angmsdae":"⦬","angmsdaf":"⦭","angmsdag":"⦮","angmsdah":"⦯","angmsd":"∡","angrt":"∟","angrtvb":"⊾","angrtvbd":"⦝","angsph":"∢","angst":"Å","angzarr":"⍼","Aogon":"Ą","aogon":"ą","Aopf":"𝔸","aopf":"𝕒","apacir":"⩯","ap":"≈","apE":"⩰","ape":"≊","apid":"≋","apos":"\'","ApplyFunction":"⁡","approx":"≈","approxeq":"≊","Aring":"Å","aring":"å","Ascr":"𝒜","ascr":"𝒶","Assign":"≔","ast":"*","asymp":"≈","asympeq":"≍","Atilde":"Ã","atilde":"ã","Auml":"Ä","auml":"ä","awconint":"∳","awint":"⨑","backcong":"≌","backepsilon":"϶","backprime":"‵","backsim":"∽","backsimeq":"⋍","Backslash":"∖","Barv":"⫧","barvee":"⊽","barwed":"⌅","Barwed":"⌆","barwedge":"⌅","bbrk":"⎵","bbrktbrk":"⎶","bcong":"≌","Bcy":"Б","bcy":"б","bdquo":"„","becaus":"∵","because":"∵","Because":"∵","bemptyv":"⦰","bepsi":"϶","bernou":"ℬ","Bernoullis":"ℬ","Beta":"Β","beta":"β","beth":"ℶ","between":"≬","Bfr":"𝔅","bfr":"𝔟","bigcap":"⋂","bigcirc":"◯","bigcup":"⋃","bigodot":"⨀","bigoplus":"⨁","bigotimes":"⨂","bigsqcup":"⨆","bigstar":"★","bigtriangledown":"▽"}')
        let levelDocs: Map<string, string> = new Map(Object.entries(obj));
        let levelDocs1: Map<string, string> = new Map(Object.entries(obj1));
        let arr = new Array<Map<string, string>>()
        arr[0] = levelDocs
        arr[1] = levelDocs1
        for (let i = 0; i < arr.length; i++) {
            let doc = arr[i]
            it(levels[i], 0, () => {
                for (const e of Object.keys(doc)) {
                    for (let l = i; l < levels.length; l++) {
                        expect(decode(`&${e};`, l)).assertEqual(doc[e]);
                        expect(decode(`&${e};`, {
                            level: l
                        })).assertEqual(
                            doc[e],
                        );
                    }
                }
            });

            it(levels[i], 0, () => {
                for (const e of Object.keys(doc)) {
                    for (let l = i; l < levels.length; l++) {
                        expect(decodeStrict(`&${e};`, l)).assertEqual(doc[e]);
                        expect(
                            decode(`&${e};`, {
                                level: l,
                                mode: DecodingMode.Strict,
                            }),
                        ).assertEqual(doc[e]);
                    }
                }
            });

            it(levels[i], 0, () => {
                for (const e of Object.keys(doc)) {
                    for (let l = i; l < levels.length; l++) {
                        const encoded = encode(doc[e], l);
                        const decoded = decode(encoded, l);
                        expect(decoded).assertEqual(doc[e]);
                    }
                }
            });

            it("should_only_encode_non_ASCII_values_if_asked", 0, () => {
                expect(
                    encode("Great #'s of 🎁", {
                        level: i,
                        mode: EncodingMode.ASCII,
                    }),
                ).assertEqual("Great #&apos;s of &#x1f381;");
            })
        }



        const astral = [
            ["1d306", "\uD834\uDF06"],
            ["1d11e", "\uD834\uDD1E"],
        ];

        const astralSpecial = [
            ["80", "\u20AC"],
            ["110000", "\uFFFD"],
        ];

        for (let i = 0; i < astral.length; i++) {
            let c = astral[i][0]
            let value = astral[i][1]
            it(`should_decode}`, 0, () => {
                expect(decode(`&#x${c};`)).assertEqual(value);
            })

            it(`should_encode`, 0, () => {
                expect(encode(value)).assertEqual(`&#x${c};`);
            })
        }

        for (let i = 0; i < astralSpecial.length; i++) {
            let c = astralSpecial[i][0]
            let value = astralSpecial[i][1]
            it(`should_decode_special`, 0, () => {
                expect(decode(`&#x${c};`)).assertEqual(value);
            })
        }

        it("should_always_decode_ASCII_chars", 0, () => {
            for (let i = 0; i < 0x7f; i++) {
                const c = String.fromCharCode(i);
                expect(decodeXML(escapeUTF8(c))).assertEqual(c);
            }
        });

        it("should_keep_UTF8_characters", 0, () => {
            expect(escapeUTF8('ß < "ü"')).assertEqual(`ß &lt; &quot;ü&quot;`);
        })
    })
}


function cb(cp: number, consumed: number): void {
    console.info(`Decoded code point: ${cp}, consumed units: ${consumed}`);
}