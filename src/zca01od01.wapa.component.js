sap.ui.define(["sap/ui/core/UIComponent","sap/ui/Device","sync/zca01od01/model/models"],function(e,t,i){"use strict";return e.extend("sync.zca01od01.Component",{metadata:{manifest:"json"},init:function(){e.prototype.init.apply(this,arguments);this.getRou+
ter().initialize();this.setModel(i.createDeviceModel(),"device")}})});                                                                                                                                                                                         