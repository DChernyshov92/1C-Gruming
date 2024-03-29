﻿Функция ПолучитьАналитикуПроводки()    
    ОплатаОтПокупателя = Перечисления.ВидыОперацийПоступления.ОплатаОтПокупателя;
    ВозвратОтПоставщика = Перечисления.ВидыОперацийПоступления.ВозвратОтПоставщика;
    ОплатаПоБанковскимКартам = Перечисления.ВидыОперацийПоступления.ОплатаПоБанковскимКартам;
        
    СтруктураАналитики = Новый Структура;
    СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РассчетныеСчета);
    СтруктураАналитики.Вставить("СубконтоДебет", РасчетныйСчет);
    Если ВидОперации = ОплатаОтПокупателя Тогда
        СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);
        СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Оплата от покупателя на расчетный счет");
    ИначеЕсли ВидОперации = ВозвратОтПоставщика Тогда
        СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками);    
        СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат средств поставщику с расчетного счета");
    ИначеЕсли ВидОперации = ОплатаПоБанковскимКартам Тогда 
        СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.ПереводыВПути);
        СтруктураАналитики.Вставить("СубконтоКредит", ЭквайринговыйТерминал);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Поступление на расчетный счет по операциям с банковскими картами");
    КонецЕсли;
	Возврат СтруктураАналитики;    
КонецФункции

Процедура ОбработкаПроведения(Отказ, Режим)
	//Денежные средства
	Движения.ДенежныеСредства.Записывать = Истина;
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Безналичные;
	Движение.БанковскийСчётКасса = РасчетныйСчет;
	Движение.Сумма = СуммаДокумента;
	//Бухгалтерия
	АналитикаПроводки = ПолучитьАналитикуПроводки();
    Движения.Хозрасчетный.Записывать = Истина;    
	Если ВидОперации = Перечисления.ВидыОперацийПоступления.ВзносНаличными Тогда
	    Возврат;    
	КонецЕсли;
	Движение = Движения.Хозрасчетный.Добавить();
	Движение.СчетДт = АналитикаПроводки.СчетДебета;
	Движение.СчетКт = АналитикаПроводки.СчетКредита;
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = АналитикаПроводки.СодержаниеОперации;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, АналитикаПроводки.СубконтоДебет);
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, АналитикаПроводки.СубконтоКредит);
КонецПроцедуры 

Функция ПолучитьДанныеПоРеализацииТоваровИУслуг(ДанныеЗаполнения) 
    Запрос = Новый Запрос; 
    Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);    
        Запрос.Текст=
        "ВЫБРАТЬ
        |    РеализацияТоваровИУслуг.Клиент КАК Плательщик,
        |    РеализацияТоваровИУслуг.Сумма КАК СуммаДокумента,
        |    РеализацияТоваровИУслуг.Ссылка КАК ДокументОснование,
        |    ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступления.ОплатаОтПокупателя) КАК ВидОперации
        |ИЗ
        |    Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
        |ГДЕ
        |    РеализацияТоваровИУслуг.Ссылка = &Ссылка";
        
    Выборка =  Запрос.Выполнить().Выбрать();
    Выборка.Следующий(); 
    Возврат Выборка;
КонецФункции

Функция ПолучитьДанныеПоПоступлениюТоваровИМатериалов(ДанныеЗаполнения) 
    Запрос = Новый Запрос; 
    Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
        Запрос.Текст=
        "ВЫБРАТЬ
        |    ПоступлениеТоваров.Поставщик КАК Плательщик,
        |    ПоступлениеТоваров.ДоговорПоставщика КАК ДоговорКонтрагента,
        |    ПоступлениеТоваров.СуммаДокумента КАК СуммаДокумента,
        |    ПоступлениеТоваров.Ссылка КАК ДокументОснование,
        |    ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступления.ВозвратОтПоставщика) КАК ВидОперации
        |ИЗ
        |    Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
        |ГДЕ
        |    ПоступлениеТоваров.Ссылка = &Ссылка";
        
    Выборка =  Запрос.Выполнить().Выбрать();
    Выборка.Следующий(); 
    Возврат Выборка;    
КонецФункции

Функция ПолучитьДанныеПоПоступлениюУслуг(ДанныеЗаполнения) 
    Запрос = Новый Запрос; 
    Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
        Запрос.Текст=
        "ВЫБРАТЬ
        |    ПоступлениеУслуг.Поставщик КАК Плательщик,
        |    ПоступлениеУслуг.ДоговорПоставщика КАК ДоговорКонтрагента,
        |    ПоступлениеУслуг.СуммаДокумента КАК СуммаДокумента,
        |    ПоступлениеУслуг.Ссылка КАК ДокументОснование,
        |    ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступления.ВозвратОтПоставщика) КАК ВидОперации
        |ИЗ
        |    Документ.ПоступлениеУслуг КАК ПоступлениеУслуг
        |ГДЕ
        |    ПоступлениеУслуг.Ссылка = &Ссылка";
    
    Выборка =  Запрос.Выполнить().Выбрать();
    Выборка.Следующий();     
    Возврат Выборка;    
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ТипДокументаОснования = ТипЗнч(ДанныеЗаполнения);
    ТипДокументаРеализацияТоваровИУслуг = Тип("ДокументСсылка.РеализацияТоваровИУслуг");
    ТипДокументаПоступлениеТоваровИМатериалов = Тип("ДокументСсылка.ПоступлениеТоваров");
    ТипДокументаПоступлениеУслуг = Тип("ДокументСсылка.ПоступлениеУслуг");
    ДанныеЗаполенияОснования = Новый Структура;
    Если ТипДокументаОснования = ТипДокументаРеализацияТоваровИУслуг Тогда
        ДанныеЗаполенияОснования  = ПолучитьДанныеПоРеализацииТоваровИУслуг(ДанныеЗаполнения);
    ИначеЕсли ТипДокументаОснования = ТипДокументаПоступлениеТоваровИМатериалов Тогда 
        ДанныеЗаполенияОснования = ПолучитьДанныеПоПоступлениюТоваровИМатериалов(ДанныеЗаполнения);
    ИначеЕсли ТипДокументаОснования = ТипДокументаПоступлениеУслуг Тогда
        ДанныеЗаполенияОснования = ПолучитьДанныеПоПоступлениюУслуг(ДанныеЗаполнения);
    КонецЕсли;
    ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполенияОснования);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
    Если НЕ ЗначениеЗаполнено(АвторДокумента) Тогда
        АвторДокумента = ПараметрыСеанса.ТекущийПользователь; 
    КонецЕсли;
КонецПроцедуры