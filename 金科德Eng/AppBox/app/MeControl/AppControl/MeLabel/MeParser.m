//
//  MeParser.m
//  EBooks
//
//  Created by  on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MeParser.h"

@implementation MeParser

//return autorelease;
+ (id)parser
{
    return [[[[self class] alloc] init] autorelease];
}

//获取标签属性
- (NSMutableDictionary *)getAttributed:(const char *)str I:(long *)i Len:(long)len
{
    long l = 0;
    char buffer[255],chr;
    NSString *key;
    
    str += *i;
    len -= *i;
    while (l<len && (chr=str[l])) {
        if(chr==' ' || chr=='"') break;
        buffer[l] = str[l];
        if(++l>ATT_MAX_KEY) return NULL;
    }
    buffer[l] = 0;
    
    key = [NSString stringWithUTF8String:buffer];
    SEL sel = NSSelectorFromString([NSString stringWithFormat:ATT_KEY_SEL,key]);
    if([self respondsToSelector:sel]){
        long d = 0;
        str += l;
        len -= l;
        while (d<len && (chr=str[d])) {
            d++;
            if(chr=='"') break;
            if(chr!=' ') return NULL;
        }
        str += d;
        len -= d;
        l += d;
        d = 0;
        while (d<len && (chr=str[d])) {
            if(chr=='"') break;
            buffer[d] = chr;
            if(++d>254) return NULL;
        }
        buffer[d] = 0;
        while (d<len && (chr=str[d])) {
            if(chr=='>') break;
            if(++d>255) return NULL;
        }
        if(chr=='>'){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:key forKey:ATT_KEY_KEY];
            [self performSelector:sel withObject:(id)buffer withObject:(id)&dic];
            *i += l + d;
            return dic;
        }
    }
    
    return NULL;
}

//解析标签
- (char *)parserArr:(char *)str Name:(char *)name Att:(char *)att Nl:(long *)nl
{
    long len = strlen(str);
    int s,n,a;
    char chr,*res = NULL;
    for (int i=s=n=a=*nl=0; i<len; i++) {
        chr = str[i];
        switch (s) {
            case 0:
                if(chr!=' ' && chr!=';'){
                    --i;
                    s = n?2:1;
                }
                break;
            case 1:
                if(chr==':'){
                    s = 0;
                }else if(chr==';'){
                    res = str+i;
                    i = len;
                }else if(chr!=' '){
                    name[n]=chr;
                    if(++n > 255) return NULL;
                }
                break;
            case 2:
                if(chr==';'){
                    res = str+i;
                    i = len;
                }else if(chr != ' '){
                    att[a]=chr;
                    if(++a > 255) return NULL;
                }
                break;
            default:
                break;
        }
    }
    
    if(n){
        att[a] = 0;
        name[n] = 0;
        *nl = n;
    }
    
    return res;
}

//获取标签属性Font
- (void)getArr_font:(char *)str Dic:(NSMutableDictionary **)dic
{
    long nl;
    char name[255],att[255];
    
    while (str) {
        str = [self parserArr:str Name:name Att:att Nl:&nl];
        if(nl<1) continue;
        
        if(nl==ATT_COLOR_LEN && memcmp(name, ATT_COLOR_CHR, ATT_COLOR_LEN)==0){
            float r,g,b,a;
            sscanf(att, "%f,%f,%f,%f",&r,&g,&b,&a);
            [*dic setObject:[UIColor colorWithRed:r green:g blue:b alpha:a] forKey:ATT_KEY_COLOR];
        }
        else if(nl==ATT_SIZE_LEN && memcmp(name, ATT_SIZE_CHR, ATT_SIZE_LEN)==0){
            float size;
            sscanf(att, "%f",&size);
            [*dic setObject:[NSNumber numberWithFloat:size] forKey:ATT_KEY_SIZE];
        }
    }
}

//补齐标签
- (BOOL)endAttributed:(NSMutableDictionary *)attDic Str:(const char *)str I:(long *)i Len:(long)len
{
    const char *key = [[NSString stringWithFormat:ATT_KEY_END,[attDic valueForKey:ATT_KEY_KEY]] UTF8String];
    long l = strlen(key);
    if(l <= (len -*i) || memcmp(key, str+*i, l)==0){
        *i += l - 1;
        return true;
    }
    return false;
}

//htmlParser
- (NSString *)htmlParser:(NSString *)html AttAry:(NSMutableArray **)attAry
{
    NSString *txt = @"";
    
    //解析属性
    NSRange rang;
    *attAry = [[NSMutableArray alloc] init];
    NSMutableDictionary *attDic = NULL;
    const char *str = [html UTF8String];
    char buffer[255];
    int l,e,s;
    long len = strlen(str);
    for(long i=l=e=s=0; i<len; i++){
        if(e && l){
            memcpy(buffer, str+i-l-1, l);
            buffer[l] = 0;
            txt = [txt stringByAppendingString:[NSString stringWithUTF8String:buffer]];
            e=l=0;
        }
        switch (s) {
                //普通文本
            case 0:
                if(str[i]=='<'){
                    e = 1;
                    s = 1;
                }else{
                    if(++l >= 254) e = 1;
                }
                break;
                //自定义标签
            case 1:
                attDic = [self getAttributed:str I:&i Len:len];
                if(attDic){
                    e = 0;
                    s = 2;
                    rang.location = [txt length];
                    rang.length = 0;
                }else{
                    //避免<<
                    ++l;
                    --i;
                    s = 0;
                }
                break;
                //标签可能结束
            case 2:
                if(str[i]=='<'){
                    e = 1;
                    s = 3;
                }else{
                    if(++l >= 254) e = 1;
                }
                break;
                //标签结束判断
            case 3:
                if([self endAttributed:attDic Str:str I:&i Len:len]){
                    rang.length = [txt length]-rang.location;
                    if(rang.length>0){
                        [attDic setObject:[NSValue valueWithRange:rang] forKey:ATT_KEY_RANG];
                        [*attAry addObject:attDic];
                    }
                    s = 0;
                }else{
                    //避免<<
                    --i;
                    s = 2;
                }
                break;
            default:
                break;
        }
    }
    //尾部文字
    if(l){
        txt = [txt stringByAppendingString:[NSString stringWithUTF8String:str+len-l]];
    }
    
    //属性内存管理
    [*attAry autorelease];
    return txt;
}

@end
