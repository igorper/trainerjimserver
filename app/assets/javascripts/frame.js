function TraineeDropDown() {
    var self = this;
    self.trainees = ko.observableArray([]);
    
    self.fetchTrainees = function () {
        $.getJSON(trainees_url, {}, function (d) {
            self.trainees($.map(d, function (d) {
                return ko.mapping.fromJS(d);
            }));
        });
    };
    
    self.fetchTrainees();
}