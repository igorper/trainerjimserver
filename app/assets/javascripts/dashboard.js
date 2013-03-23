//= require jquery.flot
//= require jquery.flot.resize
//= require knockout-2.2.1
//= require knockout.mapping

var measurementData = [];
var comments = [];

$("document").ready(function() {    
    var placeholder = $("#placeholder");
    $.getJSON('/users/list.json', function(data) {
        function UsersViewModel() {
            self = this;
            
            ///Users display
            self.users = ko.mapping.fromJS(data);
            self.selected = ko.observable(2);
            
            
            ///Calendar
            self.calendar = ko.observable([]),
            self.currentMonthIndex = ko.observable(0),   
            self.selectedDayIndex = ko.observable(-1),           
            self.calendarVisible = ko.computed(function(){
                return self.calendar() && self.calendar().length > 0;
            }),
            self.currentMonth = ko.computed(function(){
                return self.calendarVisible() && self.calendar()[self.currentMonthIndex()];
            }),
            
            ///Measurements
            self.measurement = ko.observable(), 
            self.selectedExercise = ko.observable(),
            self.exerciseExecutions = ko.observable(),
            
            self.exerciseTypes = ko.observable(),
            self.typesVisible = ko.computed(function(){
                return self.exerciseTypes() !== undefined && self.exerciseTypes().length > 0;
            }),
                    
            self.onExerciseClick = function(element){
                console.log(element);
                self.selectedExercise(element);
                self.exerciseExecutions(element.executions);
            },
                    
            self.onGraphChangeButton = function(element){
                    console.log(element);
                    setUpGraph(placeholder,getGraphData(measurementData, element.start_timestamp, element.end_timestamp));
                    
                    placeholder.bind("plotclick", onClick);
                    placeholder.bind("plothover", onHover);
            },
            

            self.scrollMonth =function(ammount){
                i = self.currentMonthIndex();
                i+=ammount;
                if(i>=self.calendar().length)
                {
                    i=0;
                }else if(i<0){
                    i = self.calendar().length - 1;
                }                
                self.currentMonthIndex(i);
                self.selectedDayIndex(-1);
            },
    
            self.selectedUser = ko.computed(function() {
                return self.users()[self.selected()];
            });
            self.statisticsVisible = ko.observable(function() {
                return self.selected() >= 0 && self.selected() < self.users().length;
            }),
                    
            self.selectUsers = function(index) {
                self.selected(index);
                $.getJSON("/dashboard/exercisedates/"+self.selectedUser().id()+".json",function(data){
                       self.calendar(data), 
                       self.currentMonthIndex(0)
                });
            },
            self.measurementSelected = function(index,el){
                self.selectedDayIndex(index);
                $.getJSON("/dashboard/measurement/"+el.measurements[0].id,function(data){
                    self.exerciseTypes(data.types);
                    self.measurement(data.measurement);
                    comments = data.measurement.measurement_comment;
                    measurementData = eval(data.measurement.data);        
                    
                    //Clear graph display
                    self.selectedExercise(null);
                    self.exerciseExecutions([]);
                });
            }
                   
        }
        ;
        ko.applyBindings(new UsersViewModel());
    });
});



function getGraphData(measurements, start, stop) {
///Gets the readings and comments for a given interval
    startindex = 1;
    stopindex = measurements.length-1;
    for (i = 1; i < measurements.length; i += 2) {
        if (measurements[i] < start) {
            startindex = i;
        }
        if (measurements[i] > stop) {
            stopindex = i;
            break;
        }
    }
    
    //find comments
    commentList = [];
    for(i = 0;i<comments.length;i++){
        var time = comments[i].timestamp;
        if(time>=startindex && time<=stopindex){
            commentList.push(
                [measurements[time],measurements[time-1],comments[i].comment]);
        }
    }
    
    console.log(measurements.slice(startindex - 1, stopindex + 1));
    console.log(commentList);

    return [measurements.slice(startindex - 1, stopindex + 1),commentList];
}

var json = [-100488, 137446, -100488, 137488, -100879, 137530, -100488, 137572, -102052, 137635, -100879, 137677, -102834, 137719, -102052, 138034, -101270, 138097, -100879, 138139, -101661, 138181, -101270, 138223, -101661, 138265, -100488, 138307, -100488, 138370, -101270, 138412, -101661, 138538, -101270, 138580, -100488, 138643, -101270, 138769, -101661, 138811, -100879, 138958, -109090, 139105, -89540, 139147, -103225, 139189, -100488, 139315, -101661, 139483, -100097, 139525, -100097, 139567, -101270, 139882, -101270, 139946, -100488, 139988, -102834, 140135, -101270, 140387, -99315, 140450, -99706, 140492, -100488, 140534, -100879, 140576, -101661, 140618, -100488, 140744, -102052, 140975, -99315, 141038, -100097, 141080, -100879, 141206, -102052, 141248, -101270, 141290, -102052, 141416, -102443, 141584, -101270, 141647, -100488, 141794, -99706, 141857, -100097, 141899, -100097, 141962, -99706, 142088, -98533, 142130, -101270, 142173, -102443, 142215, -103225, 142341, -100097, 142383, -104007, 142446, -101661, 142530, -101661, 142572, -100879, 142614, -100488, 142740, -101661, 142782, -100097, 142824, -102052, 142950, -101270, 142992, -100879, 143034, -104789, 143160, -108699, 143224, -110263, 143266, -111827, 143350, -112609, 143392, -108699, 143434, -111436, 143476, -107135, 143539, -105180, 143581, -103616, 143917, -96969, 143981, -104007, 144023, -100879, 144065, -102052, 144107, -106353, 144149, -106353, 144843, -103225, 144885, -100488, 144927, -97360, 144969, -94623, 145095, -93059, 145137, -93059, 145284, -94623, 145410, -99706, 145473, -98533, 145515, -103225, 145641, -102443, 145809, -96969, 145851, -103616, 145977, -100879, 146019, -104398, 146061, -104398, 146187, -106744, 146229, -109090, 146397, -113391, 146544, -112609, 146586, -106744, 146628, -113000, 146670, -111045, 146796, -110654, 146838, -106353, 146985, -105571, 147132, -108699, 147174, -108308, 147216, -97751, 147447, -86412, 147573, -89149, 147804, -100488, 147846, -104789, 147888, -101661, 148035, -98142, 148161, -97360, 148203, -96187, 148245, -95405, 148371, -96187, 148413, -95796, 148497, -92668, 148539, -99315, 148854, -102834, 149169, -105180, 149211, -105571, 149337, -105962, 149379, -101270, 149421, -107917, 149463, -104789, 149589, -108699, 149631, -109481, 149673, -111045, 149800, -102443, 149842, -112609, 149884, -110654, 149968, -111436, 150010, -109872, 150094, -109872, 150136, -106744, 150493, -106353, 150535, -103225, 150598, -102443, 150640, -98533, 150682, -100488, 150724, -97751, 150766, -96969, 150808, -91104, 150871, -102052, 150913, -97751, 150955, -90322, 150997, -84848, 151039, -91104, 151165, -89931, 151207, -92668, 151249, -102052, 151396, -102052, 151482, -101270, 151524, -100097, 151650, -99315, 151692, -98142, 151734, -97360, 151818, -96578, 151860, -96187, 151902, -95014, 152028, -94623, 152070, -93450, 152112, -98533, 152343, -98142, 152490, -105962, 152532, -98924, 152574, -105962, 152679, -95014, 152721, -105180, 152763, -109481, 152805, -101270, 152931, -110263, 152973, -105180, 153015, -106744, 153099, -107526, 153141, -104398, 153204, -107526, 153246, -111827, 153540, -111045, 153603, -109481, 153645, -107917, 153750, -106353, 154023, -107135, 154086, -103616, 154128, -96578, 154254, -97751, 154296, -89149, 154338, -99706, 154443, -100488, 154485, -85239, 154527, -98533, 154653, -86412, 154695, -87976, 154737, -95014, 154779, -102834, 154863, -104007, 154905, -104398, 154947, -100879, 154989, -100488, 155031, -100879, 155094, -100488, 155220, -98533, 155262, -98142, 155304, -94232, 155430, -91886, 155472, -91104, 155514, -95796, 155640, -96187, 155682, -96969, 155724, -97751, 155808, -96578, 155850, -97751, 155892, -97360, 155934, -95014, 155976, -93841, 156018, -104789, 156060, -93841, 156102, -98924, 156144, -105962, 156186, -104789, 156249, -109872, 156291, -107526, 156333, -104398, 156459, -110654, 156501, -107135, 156543, -107917, 156669, -106353, 156711, -114565, 156753, -107917, 156879, -113782, 156963, -111045, 157005, -111436, 157131, -107917, 157173, -107526, 157215, -100879, 157362, -104398, 157530, -104007, 157656, -100488, 157719, -96187, 157761, -86412, 157803, -99315, 157929, -96969, 157971, -87585, 158013, -92668, 158181, -89540, 158223, -98533, 158832, -96969, 158958, -96969, 159000, -97751, 159042, -94623, 159084, -98142, 159315, -97360, 159357, -97751, 159399, -97360, 159546, -94623, 159588, -99315, 159630, -100488, 159756, -102443, 159798, -107526, 159840, -105571, 159987, -113000, 160113, -101661, 160155, -104789, 160197, -111827, 160449, -107135, 160491, -115738, 160554, -103225, 160974, -102834, 161016, -104789, 161058, -98142, 161184, -103616, 161226, -106744, 161268, -96187, 161310, -85630, 161436, -87585, 161478, -98924, 161520, -80938, 161604, -86412, 161646, -100879, 161688, -100879, 162066, -101661, 162108, -100488, 162150, -99315, 162192, -98533, 162234, -98142, 162276, -96578, 162318, -96578, 162360, -96578, 162402, -94623, 162444, -95405, 162570, -93450, 162633, -95796, 162675, -99706, 162780, -97751, 162948, -100488, 162990, -103616, 163116, -100488, 163158, -101270, 163200, -109872, 163326, -105180, 163473, -112218, 163515, -103225, 163599, -107917, 163641, -92277, 163788, -112218, 163830, -113782, 164355, -100879, 164670, -105180, 164796, -90713, 165027, -87194, 165069, -90322, 165384, -100488, 165531, -100879, 165573, -100488, 165615, -100097, 165657, -96578, 165783, -96187, 165825, -95796, 165867, -93841, 165993, -94232, 166035, -95796, 166077, -96187, 166119, -96578, 166203, -96187, 166245, -96187, 166287, -96969, 166329, -95014, 166371, -102443, 166434, -98142, 166476, -98924, 166623, -104398, 166665, -101661, 166728, -98142, 166770, -98142, 166917, -105571, 166959, -104398, 167001, -112609, 167043, -104789, 167169, -106353, 167211, -108308, 167253, -100488, 167337, -113391, 167379, -100488, 167421, -101270, 167463, -103616, 167589, -114173, 167631, -104007, 167673, -110654, 167925, -101661, 168240, -95796, 168849, -84066, 168891, -85239, 169038, -98924, 169542, -95405, 169857, -96578, 169899, -96578, 170025, -93841, 170067, -95796, 170109, -99315, 170235, -98924, 170277, -102443, 170340, -96578, 170445, -109090, 170487, -100097, 170550, -107135, 170697, -96969, 170760, -110263, 170802, -105180, 170844, -106744, 170970, -103616, 171012, -103616, 171054, -103616, 171180, -109090, 171222, -111827, 171264, -114173, 171348, -115347, 171474, -113782, 171516, -116911, 171558, -113782, 171684, -109090, 171726, -109481, 171768, -104398, 171894, -98924, 171978, -102834, 172041, -99706, 172356, -92277, 172671, -98924, 172734, -104398, 172776, -102052, 172818, -104398, 172944, -98533, 173154, -97360, 173196, -97360, 173322, -96578, 173364, -95796, 173595, -94623, 173637, -96578, 173763, -96969, 173805, -98533, 173847, -95796, 173952, -100488, 173994, -95014, 174141, -95405, 174246, -100879, 174288, -109090, 174330, -106744, 174561, -105180, 174666, -105180, 174918, -112609, 174960, -103225, 175275, -113391, 175401, -111045, 175443, -105571, 175653, -97360, 175989, -107917, 176031, -100097, 176346, -104398, 176388, -94623, 176431, -101270, 176557, -87585, 176767, -93059, 176809, -98142, 176851, -100879, 176956, -100879, 176998, -102834, 177040, -100488, 177166, -101661, 177208, -102443, 177250, -100488, 177355, -100879, 177397, -100488, 177439, -100488, 177502, -99706, 177628, -98924, 177733, -97360, 177775, -96578, 177943, -96187, 177985, -96187, 178090, -98533, 178132, -97360, 178174, -95796, 178300, -95014, 178342, -99315, 178510, -93450, 178552, -95014, 178678, -101270, 178720, -105962, 178762, -105180, 178867, -112609, 178909, -101661, 178951, -102052, 179056, -111827, 179119, -116911, 179161, -89149, 179203, -88758, 179329, -111436, 179371, -110654, 179413, -73118, 179518, -99315, 179560, -100097, 179602, -100879, 179707, -100488, 179749, -97751, 179791, -103616, 179875, -103616, 179917, -101270, 179959, -100879, 180001, -100488, 180148, -102052, 180190, -95796, 180232, -101270, 180274, -88367, 180379, -111045, 180421, -99315, 180589, -100879, 180715, -100879, 180757, -101270, 180799, -100097, 181009, -99706, 181303, -101661, 181345, -101661, 181387, -100488, 181513, -101661, 181555, -101661, 182374, -101270, 182416, -100879, 182458, -100488, 182500, -101661, 182542, -100488, 182584, -100879, 182899, -101661, 182941, -100488, 183046];
var sets = [json, [1, 2, 3, 4, 5, 6], $.map(json, function(n) {
        return n * n;
    })];
var comments = [[[sets[0][23 * 2 + 1], sets[0][23 * 2], "hudo slab trening:)"]], [], []];
var plot;
var options = {
    legend: {
        show: false
    },
    yaxis: {
        autoscaleMargin: 0.05
    },
    xaxis: {
        autoscaleMargin: 0.05
    },
    grid: {
        show: false, //skrij osi
        hoverable: true,
        clickable: true
    }
};

var plotData;
function setUpGraph(placeholder,data) {
    plotData = [];
    
    json = data[0];
    tocke = data[1];
    
    data = [];
    for (var i = 0; i < json.length; i += 2) {
        data.push([json[i + 1], json[i]]);
    }

    plotData.push(
            {
                label: 'podatki',
                data: data,
                lines: {
                    show: true,
                    lineWidth: 2
                }});
    plotData.push({
        label: "selected",
        data: tocke,
        points: {
            show: true,
            fillColor: 'red',
            radius: 8
        }
    });
    plot = $.plot(placeholder, plotData, options);
}



function showTooltip(x, y, contents) {
    $('<div id="tooltip" contenteditable="true">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}

var previousPoint = null;
function onHover(event, pos, item) {
    $("#x").text(pos.x.toFixed(2));
    $("#y").text(pos.y.toFixed(2));
    if (item && item.series.label === "selected") {
        if (previousPoint != item.datapoint) {
            previousPoint = item.datapoint;
            $("#tooltip").remove();
            var x = item.datapoint[0].toFixed(2),
                    y = item.datapoint[1].toFixed(2),
                    //set default content for tooltip
                    content = plotData[1].data[item.dataIndex][2];
            //now show tooltip
            showTooltip(item.pageX, item.pageY, content);
        }
    }
    else {
        $("#tooltip").remove();
        previousPoint = null;
    }

}

function onClick(event, pos, item) {
    if (item) {
        if (item.series.label === "podatki") {
            $("#clickdata").text("You clicked point " + item.dataIndex + ".");
            var komentar = prompt("Dodajte komentar", "");
            var comment = [item.datapoint[0], item.datapoint[1], komentar];
            //dodamo izbrano točko in na novo izrišemo graf
            plotData[1].data.push(comment);
            plot.setData(plotData);
            plot.draw();
        } else {
            $("#clickdata").text("You clicked point " + item.dataIndex + ".");
            //brisemo tocko
            plotData[1].data[item.dataIndex] = null;
            plot.setData(plotData);
            plot.draw();
        }
    } else {
        $("#clickdata").text("Click mimo tocke.");
    }
}

function showTooltip(x, y, contents) {
    $('<div id="tooltip">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}