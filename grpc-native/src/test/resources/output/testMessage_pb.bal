public type Test1 record {|
    string name = "";
|};

public type Test3 record {|
    string[] a = [];
    float[] b = [];
    float[] c = [];
    int[] d = [];
    int[] e = [];
    int[] f = [];
    int[] g = [];
    int[] h = [];
|};

public type Test2 record {|
    string a = "";
    float b = 0.0;
    float c = 0.0;
    int d = 0;
    int e = 0;
    int f = 0;
    int g = 0;
    int h = 0;
|};

const string ROOT_DESCRIPTOR = "0A11746573744D6573736167652E70726F746F221B0A05546573743112120A046E616D6518012001280952046E616D6522770A055465737432120C0A0161180120012809520161120C0A0162180220012801520162120C0A0163180320012802520163120C0A0164180420012805520164120C0A0165180520012803520165120C0A0166180620012804520166120C0A0167180720012807520167120C0A016818082001280652016822770A055465737433120C0A0161180120032809520161120C0A0162180220032801520162120C0A0163180320032802520163120C0A0164180420032805520164120C0A0165180520032803520165120C0A0166180620032804520166120C0A0167180720032807520167120C0A0168180820032806520168620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return
    {"testMessage.proto": "0A11746573744D6573736167652E70726F746F221B0A05546573743112120A046E616D6518012001280952046E616D6522770A055465737432120C0A0161180120012809520161120C0A0162180220012801520162120C0A0163180320012802520163120C0A0164180420012805520164120C0A0165180520012803520165120C0A0166180620012804520166120C0A0167180720012807520167120C0A016818082001280652016822770A055465737433120C0A0161180120032809520161120C0A0162180220032801520162120C0A0163180320032802520163120C0A0164180420032805520164120C0A0165180520032803520165120C0A0166180620032804520166120C0A0167180720032807520167120C0A0168180820032806520168620670726F746F33"};
}

