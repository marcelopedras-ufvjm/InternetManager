/**
 * Created by marcelo on 17/02/15.
 */
mainApp.controller('InternetLabsController',['$http','$log','$location','loginSession','connectionManager',function($http,$log,$location,loginSession,connectionManager){
    console.log('InternetLabsController criado')
    var self = this;
    var form_off = '/app/views/form_internet_off.html';
    var form_off_data = {
        id: '',
        lab: '',
        order: undefined,
        start_time: undefined,
        end_time: undefined
    };

    self.timeOpt = {
        start_time: {
            hstep: 0,
            mstep: 0
        },
        end_time: {
            hstep: 1,
            mstep: 10
        },

        ismeridian: false

    };

    self.toggleMode = function() {
        self.timeOpt.ismeridian = ! self.timeOpt.ismeridian;
    };

    self.update = function() {
        var d = new Date();
        d.setHours( 14 );
        d.setMinutes( 0 );
        self.timeOpt.mytime = d;
    };

    self.changed = function () {
        console.log(form_off_data.start_time);
        console.log(form_off_data.end_time);

        if(form_off_data.start_time >= form_off_data.end_time) {
            form_off_data.end_time = form_off_data.start_time;
            var aux = new Date(form_off_data.start_time);
            aux.setMinutes(aux.getMinutes()+10);
            form_off_data.end_time = aux;
        }
        //$log.log('Time changed to: ' + self.timeOpt.mytime);
    };

    self.clear = function() {
        self.timeOpt.mytime = null;
    };



    var time_pattern = /^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$/;

    var downConnection = function() {
        var lab = retrieveLab(form_off_data.order);
        lab.internet = false;
        lab.start_time = moment(form_off_data.start_time).format("HH:mm");//moment(form_off_data.start_time).format("DD/MM/YYYY h:mm:ss");
        lab.end_time = moment(form_off_data.end_time).format("HH:mm");//moment(form_off_data.end_time).format("DD/MM/YYYY h:mm:ss");
        lab.by = loginSession.getUser();
        persist(lab);
    };

    var upConnection = function(l) {
        var lab = retrieveLab(l);
        lab.internet = true;
        lab.start_time = 'n/a';
        lab.end_time = 'n/a';
        lab.by = loginSession.getUser();
        persist(lab);
    };

    var showForm = function() {
        $('#myModal').modal('show');
    };

    var hideForm = function() {
        $('#myModal').modal('hide');
    };

    var initForm = function(labObj) {

        //t=Time();

        form_off_data.start_time = new Date();//t.to_s();

        var aux = new Date(form_off_data.start_time);
        aux.setMinutes(aux.getMinutes()+10);
        form_off_data.end_time = aux;// t.addHour(1).to_s();
        form_off_data.lab = labObj.room_name;
        form_off_data.id = labObj.id;
        form_off_data.order = labObj.order;
    };


    var retrieveLab = function(lab) {
        return self.labs[lab];
    };

    var Time = function() {
        var d = new Date();
        var h = d.getHours();
        var m = d.getMinutes();
        var s = d.getSeconds();
        var obj = {
            to_s: function() {
                var r = h + ":" + m + ":" + s
                return r;
            },
            addHour : function(hour) {
                h = h + hour;
                return obj;
            },

            subHour : function(hour) {
                h = h - hour;
                return obj;
            }
        };

        return obj;
    };

    var persist = function(lab) {
        //    id: c.id,
        //    internet: c.internet,
        //    start_time: c.start_time,
        //    end_time: c.end_time,
        //    username: c.username
        connectionManager.setConnection(lab)
    };


    self.labs = [];

    self.getFormData = function() {
        return form_off_data;
    };

    self.editable = function() {
        if(loginSession.isLoggedIn()) {
            self.partial = "/app/views/partials/_on_off_internet.html";
        } else {
            self.partial = "/app/views/partials/_show_internet_status.html";
        }

        return self.partial;
    };

    self.markAsOn = function(lab) {
        var status = retrieveLab(lab).internet;
        return {
            'btn-success': status,
            'active': status

        }
    };

    self.markAsOff = function(lab) {
        var status = retrieveLab(lab).internet;
        return {
            'btn-danger': !status,
            'active': !status
        }
    };

    self.turnOn = function(labOrder) {
        upConnection(labOrder);
        console.log(retrieveLab(labOrder).internet);
    };

    self.turnOff = function(lab) {
        var l = retrieveLab(lab);
        initForm(l);
        showForm();
        console.log(retrieveLab(lab).internet);
    };

    self.applyConnectionChanges = function() {
        downConnection();
        hideForm();
    };



    self.modal_path = function() {
        return form_off;
    };

    //$http.get('/connection/list').then(function(response){
    //    self.labs = response.data;
    //}, function(error){});

    connectionManager.initConnections().then(function(response){
        self.labs = response;
    },function(errResponse){});
    hideForm();

}]);