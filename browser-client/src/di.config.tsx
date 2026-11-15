/** @jsx svg */
import {
    Action,
    ConsoleLogger,
    GEdge,
    GLabel,
    GLabelView,
    GNode,
    IDiagramOptions,
    IView,
    GModelElement,
    LogLevel,
    MouseListener,
    Point,
    PolylineEdgeView,
    RenderingContext,
    RoundedCornerNodeView,
    STANDALONE_MODULE_CONFIG,
    TYPES,
    angleOfPoint,
    bindAsService,
    bindOrRebind,
    configureDefaultModelElements,
    configureModelElement,
    createDiagramOptionsModule,
    findParent,
    initializeDiagramContainer,
    popupFeature,
    svg,
    toDegrees
} from '@eclipse-glsp/client';
import { Container, ContainerModule, injectable } from 'inversify';
import { VNode } from 'snabbdom';

/** A dependency: a polyline with an arrowhead at its target */
@injectable()
export class DependencyEdgeView extends PolylineEdgeView {
    protected override renderAdditionals(edge: GEdge, segments: Point[], context: RenderingContext): VNode[] {
        const additionals = super.renderAdditionals(edge, segments, context);
        const p1 = segments[segments.length - 2];
        const p2 = segments[segments.length - 1];
        const angle = toDegrees(angleOfPoint({ x: p1.x - p2.x, y: p1.y - p2.y }));
        additionals.push(
            <path
                class-sprotty-edge={true}
                class-arrow={true}
                d='M 1,0 L 10,-4 L 10,4 Z'
                transform={`rotate(${angle} ${p2.x} ${p2.y}) translate(${p2.x} ${p2.y})`}
            />
        );
        return additionals;
    }
}

/**
 * The server sends labels without position (it does no text layout), so center the label in its node.
 */
@injectable()
export class CenteredLabelView extends GLabelView implements IView {
    override render(label: Readonly<GLabel>, context: RenderingContext): VNode | undefined {
        const parent = label.parent as GNode;
        const size = parent && parent.size ? parent.size : { width: 0, height: 0 };
        return (
            <text class-sprotty-label={true} x={size.width / 2} y={size.height / 2} text-anchor='middle' dominant-baseline='central'>
                {label.text}
            </text>
        );
    }
}

/** The args the Pharo server put on an element (not declared on GNode, but copied from the model) */
function argsOf(element: Readonly<GNode | GLabel>): { [key: string]: string } {
    return ((element as any).args ?? {}) as { [key: string]: string };
}

/** A DSM cell: a rectangle in the color the server computed, its weight centered, its details as tooltip */
@injectable()
export class DsmCellView implements IView {
    render(node: Readonly<GNode>, context: RenderingContext): VNode | undefined {
        const args = argsOf(node);
        return (
            <g class-dsm-cell={true} class-selected={node.selected}>
                <rect class-dsm-cell-box={true} width={node.size.width} height={node.size.height} fill={args.fill ?? '#e6e6e6'} />
                <title>{args.title ?? ''}</title>
                {context.renderChildren(node)}
            </g>
        );
    }
}

/** A DSM row or column header: no box, only its label */
@injectable()
export class DsmHeaderView implements IView {
    render(node: Readonly<GNode>, context: RenderingContext): VNode | undefined {
        return (
            <g class-dsm-header={true}>
                <rect width={node.size.width} height={node.size.height} fill='transparent' />
                <title>{(node.children[0] as GLabel | undefined)?.text ?? ''}</title>
                {context.renderChildren(node)}
            </g>
        );
    }
}

/** The name of a row: right-aligned, next to its row of cells */
@injectable()
export class DsmRowLabelView extends GLabelView implements IView {
    override render(label: Readonly<GLabel>, context: RenderingContext): VNode | undefined {
        const size = (label.parent as GNode).size;
        return (
            <text class-sprotty-label={true} class-dsm-header-label={true} class-dsm-row-label={true} x={size.width - 8} y={size.height / 2} text-anchor='end' dominant-baseline='central'>
                {label.text}
            </text>
        );
    }
}

/** The name of a column: written upwards, ending just above its column of cells */
@injectable()
export class DsmColumnLabelView extends GLabelView implements IView {
    override render(label: Readonly<GLabel>, context: RenderingContext): VNode | undefined {
        const size = (label.parent as GNode).size;
        const x = size.width / 2;
        const y = size.height - 8;
        return (
            <text
                class-sprotty-label={true}
                class-dsm-header-label={true}
                class-dsm-column-label={true}
                x={x}
                y={y}
                transform={`rotate(-90 ${x} ${y})`}
                text-anchor='start'
                dominant-baseline='central'
            >
                {label.text}
            </text>
        );
    }
}

/**
 * Tells the Pharo server which DSM cell is under the mouse (custom action 'dsmHoverCell', handled by
 * GLSPDSMHoverCellActionHandler): it answers with the model where the cells of that cell's SCC are red.
 * Sent only when the cell under the mouse changes; without cellId when the mouse leaves the cells.
 */
@injectable()
export class DsmHoverMouseListener extends MouseListener {
    protected hoveredCellId: string | undefined;

    override mouseOver(target: GModelElement, event: MouseEvent): Action[] {
        const cell = findParent(target, element => element.type === 'dsm-cell');
        return this.hover(cell?.id);
    }

    override mouseLeave(target: GModelElement, event: MouseEvent): Action[] {
        return this.hover(undefined);
    }

    protected hover(cellId: string | undefined): Action[] {
        if (cellId === this.hoveredCellId) {
            return [];
        }
        this.hoveredCellId = cellId;
        return [{ kind: 'dsmHoverCell', cellId } as Action];
    }
}

const archmapDiagramModule = new ContainerModule((bind, unbind, isBound, rebind) => {
    const context = { bind, unbind, isBound, rebind };
    bindOrRebind(context, TYPES.ILogger).to(ConsoleLogger).inSingletonScope();
    bindOrRebind(context, TYPES.LogLevel).toConstantValue(LogLevel.warn);
    configureDefaultModelElements(context);
    configureModelElement(context, 'archmap-node', GNode, RoundedCornerNodeView);
    configureModelElement(context, 'archmap-dependency', GEdge, DependencyEdgeView);
    configureModelElement(context, 'label', GLabel, CenteredLabelView, { enable: [] });
    // DSM (dsm-diagram, GLSPDSMVisualization in MooseIDE-DSM)
    // No GLSP popup (requestPopupModel, which the Pharo server does not handle): the tooltip is the cell's <title>
    configureModelElement(context, 'dsm-cell', GNode, DsmCellView, { disable: [popupFeature] });
    configureModelElement(context, 'dsm-column-header', GNode, DsmHeaderView, { disable: [popupFeature] });
    configureModelElement(context, 'dsm-row-header', GNode, DsmHeaderView, { disable: [popupFeature] });
    configureModelElement(context, 'dsm-weight', GLabel, CenteredLabelView, { enable: [] });
    configureModelElement(context, 'dsm-row-label', GLabel, DsmRowLabelView, { enable: [] });
    configureModelElement(context, 'dsm-column-label', GLabel, DsmColumnLabelView, { enable: [] });
    bindAsService(context, TYPES.MouseListener, DsmHoverMouseListener);
});

export function createContainer(options: IDiagramOptions): Container {
    return initializeDiagramContainer(new Container(), archmapDiagramModule, createDiagramOptionsModule(options), STANDALONE_MODULE_CONFIG);
}
