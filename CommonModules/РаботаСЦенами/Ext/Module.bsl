﻿Функция ЦенаНаДатуПродажи(Номенклатура, ТекДата = Неопределено, ТипЦены = Неопределено) Экспорт
	Запрос = Новый Запрос();
	Если ТипЦены = Неопределено Тогда
		ТипЦены = Перечисления.ТипыЦен.Розничная;
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЦеныСрезПоследних.Период КАК Период,
	               |	ЦеныСрезПоследних.Номенклатура КАК Номенклатура,
	               |	ЦеныСрезПоследних.ТипЦены КАК ТипЦены,
	               |	ЦеныСрезПоследних.Цена КАК Цена
	               |ИЗ
	               |	РегистрСведений.Цены.СрезПоследних(
	               |			&Период,
	               |			Номенклатура = &Номенклатура
	               |				И ТипЦены = &ТипЦены) КАК ЦеныСрезПоследних"
				   ;
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Период", ТекДата);
	Запрос.УстановитьПараметр("ТипЦены", ТипЦены);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("Цена не найдена");
		Возврат 0;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();	
	
	Возврат Выборка.Цена;
	
КонецФункции

Функция ПолучитьЦенуНаКонкретнуюДату(Номенклатура, Дата, ТипЦены) Экспорт
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	                 |	Цены.Цена КАК Цена
	                 |ИЗ
	                 |	РегистрСведений.Цены КАК Цены
	                 |ГДЕ
	                 |	Цены.Номенклатура = &Номенклатура
	                 |	И Цены.ТипЦены = &ТипЦены
	                 |	И Цены.Период = &Период";
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ТипЦены", ТипЦены);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Цена;
КонецФункции

Функция ПолучитьЦенуПоКонтрагенту(Номенклатура, Поставщик, ТекДата) Экспорт
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
		         |	ЦеныНоменклатурыПоставщиковСрезПоследних.Цена КАК Цена
		         |ИЗ
		         |	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(
		         |			&Период,
		         |			&Номенклатура = Номенклатура
		         |				И &Поставщик = Поставщик) КАК ЦеныНоменклатурыПоставщиковСрезПоследних"
				 ;
	Запрос.УстановитьПараметр("Период", ТекДата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Цена;
	Иначе
		Текст = "Цена не найдена";
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = Текст;
		Сообщение.Сообщить();
		Возврат 0;
	КонецЕсли;	
КонецФункции
