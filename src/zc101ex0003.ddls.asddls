@AbapCatalog.sqlViewAppendName: 'ZC101EX0003_V'
@EndUserText.label: '[C1] Fake Standard Table Extend'
extend view ZC101CDS0003 with ZC101EX0003 
{
   ztc1010001.zzsaknr,
   ztc1010001.zzkostl,
   ztc1010001.zzshkzg,
   ztc1010001.zzlgort
}
