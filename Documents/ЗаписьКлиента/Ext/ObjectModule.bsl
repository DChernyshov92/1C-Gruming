﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ЗаказыКлентов Приход
	Движения.ЗаказыКлиентов.Записывать = Истина;
	Для Каждого ТекСтрокаУслуги Из Услуги Цикл
		Движение = Движения.ЗаказыКлиентов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаУслуги.Услуга;
		Движение.Клиент = Клиент;
		Движение.Дата = ДатаЗаписи;
		Движение.ЗаказКлиента = Ссылка;
		Движение.Сумма = ТекСтрокаУслуги.Цена;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если НЕ ЗначениеЗаполнено(АвторДокумента) Тогда
		АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	ДлительностьУслуг = РассчитатьДатуОкончанияЗаписи();
	Если ДлительностьУслуг = 0 Тогда
    	ДлительностьУслуг = 60;
	КонецЕсли;
	ДатаОкончанияЗаписи = ДатаЗаписи + ДлительностьУслуг*60;
	
КонецПроцедуры

Функция РассчитатьДатуОкончанияЗаписи()
	ТЧУслуги = Услуги.Выгрузить(,"Услуга"); 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЧУслуги", ТЧУслуги);
	Запрос.Текст=
	"ВЫБРАТЬ
	|    ТЧУслуги.Услуга КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|    &ТЧУслуги КАК ТЧУслуги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|    СУММА(Ном.ДлительностьУслуги) КАК ДлительностьУслуги
	|ИЗ
	|    ВТ_Номенклатура КАК ВТ_Номенклатура
	|        ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
	|        ПО ВТ_Номенклатура.Номенклатура = Ном.Ссылка";

	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Если Выборка.ДлительностьУслуги = Null Тогда
		Возврат 0;
	Иначе
		Возврат Выборка.ДлительностьУслуги;
	КонецЕсли;
КонецФункции