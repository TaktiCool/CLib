class CfgCLibSettings {
    CLib_test[] = {"CLibSettingsTest"};
};

class CLibSettingsTest {
    simpleValueNumber = 1;
    simpleValueText = "This is a Text";
    simpleValueArray[] = {"Element A", "Element B", "Element C"};
    class ComplexSetting {
        value = 1;
        description = "This is a description";
    };

    class ComplexSettingForced {
        value = 1;
        description = "This is a description";
        force = 1;
    };

    class ComplexSettingClient {
        value = 1;
        description = "This is a description";
        client = 0;
    };

    class SubClass {
        simpleValueNumber = 1;
        simpleValueText = "This is a Text";
        simpleValueArray[] = {"Element A", "Element B", "Element C"};
        class ComplexSetting {
            value = 1;
            description = "This is a description";
        };

        class ComplexSettingForced {
            value = 1;
            description = "This is a description";
            force = 1;
        };

        class ComplexSettingClient {
            value = 1;
            description = "This is a description";
            client = 0;
        };
    };
};
